"""Interactive Terminal Regression

Comprueba el lanzador en una pseudoterminal POSIX, no en modo headless.
Usa Python estándar, datos temporales y copias de plugins/servidores ya instalados.
"""

import fcntl
import json
import os
from pathlib import Path
import pty
import select
import shutil
import signal
import struct
import subprocess
import tempfile
import termios
import time


ROOT = Path(__file__).resolve().parents[1]


def check_documented_commands():
    # No volver a recomendar RTK delante de la interfaz interactiva.
    for name in ("README.md", "docs/01-installation.md", "docs/05-launch-and-profiles.md"):
        for line in (ROOT / name).read_text().splitlines():
            if line.startswith("rtk ") and "nvim" in line:
                assert any(flag in line for flag in ("--headless", "--clean", "--version", " -l ")), (name, line)


def check_terminal(base, environment, arguments, expected, navigation=False, completion=None):
    pid, terminal = pty.fork()
    if pid == 0:
        os.chdir(ROOT)
        os.execvpe("sh", ["sh", str(ROOT / "scripts/launch.sh"), "-n", "-i", "NONE", *arguments], environment)

    fcntl.ioctl(terminal, termios.TIOCSWINSZ, struct.pack("HHHH", 24, 80, 0, 0))
    output = bytearray()
    finished = False

    def collect_until(predicate, seconds=5):
        deadline = time.monotonic() + seconds
        while time.monotonic() < deadline:
            if select.select([terminal], [], [], 0.05)[0]:
                try:
                    chunk = os.read(terminal, 65536)
                except OSError:
                    break
                if not chunk:
                    break
                output.extend(chunk)
            if predicate():
                return True
        return predicate()

    try:
        assert collect_until(lambda: expected in output), "La terminal no dibujó el contenido esperado."
        # La respuesta en archivo demuestra que Neovim procesó el teclado, no solo eco de la TTY.
        response = base / ("response-file.txt" if arguments else "response-empty.txt")
        expression = ':lua vim.fn.writefile({"INPUT_OK"}, ' + json.dumps(str(response)) + ")\r"
        os.write(terminal, b"\x1b" + expression.encode())
        assert collect_until(response.exists), "Neovim no procesó la entrada del teclado."
        assert response.read_text() == "INPUT_OK\n"
        if completion:
            # Un timer observa la TUI sin salir de Insert ni invocar cmp.show().
            # De ese modo probamos el menú AUTOMÁTICO, no solo respuestas del LSP.
            state = base / ("completion-" + completion["server"] + ".json")
            target = json.dumps(str(state))
            probe = (
                ':lua _G.completion_probe=vim.uv.new_timer(); '
                '_G.completion_probe:start(80,80,vim.schedule_wrap(function() '
                'local cmp=require("blink.cmp"); local items={}; '
                'for _,item in ipairs(cmp.get_items()) do '
                'items[#items+1]={label=item.label,source=item.source_id} end; '
                'local selected=cmp.get_selected_item(); local clients={}; '
                'for _,c in ipairs(vim.lsp.get_clients({bufnr=0})) do '
                'if c.initialized then clients[#clients+1]=c.name end end; '
                'local p=' + target + '; vim.fn.writefile({vim.json.encode({'
                'visible=cmp.is_visible(),items=items,selected=selected and selected.label,'
                'snippet=vim.snippet.active(),lines=vim.api.nvim_buf_get_lines(0,0,-1,false),'
                'cursor=vim.api.nvim_win_get_cursor(0),clients=clients,errmsg=vim.v.errmsg})},p..".tmp"); '
                'vim.uv.fs_rename(p..".tmp",p) end))\r'
            )
            os.write(terminal, probe.encode())

            def snapshot():
                return json.loads(state.read_text()) if state.exists() else {}

            assert collect_until(lambda: completion["server"] in snapshot().get("clients", []), seconds=40), snapshot()
            os.write(terminal, completion["keys"])

            def has_candidate():
                current = snapshot()
                return current.get("visible") and any(
                    item["label"] == completion["label"] and item["source"] == completion["source"]
                    for item in current.get("items", [])
                )

            assert collect_until(has_candidate, seconds=15), ("No apareció menú automático", snapshot())
            assert snapshot()["errmsg"] == "", snapshot()
            if completion["source"] == "snippets":
                assert snapshot().get("selected") == "html5", snapshot()
                os.write(terminal, b"\r")  # Enter: aceptar, no llamar expand() desde Lua.
                assert collect_until(lambda: snapshot().get("snippet") and any(
                    "<!DOCTYPE html>" in line for line in snapshot().get("lines", [])
                )), snapshot()
                assert b"Snippet" in output, "No dibujó el tipo de candidato en el menú."
                os.write(terminal, b"es")  # Reemplazar el primer campo seleccionado.
                assert collect_until(lambda: any('lang="es"' in line for line in snapshot().get("lines", [])))
                previous = snapshot()["cursor"]
                os.write(terminal, b"\t")
                assert collect_until(lambda: snapshot().get("cursor") != previous), "Tab no recorrió el snippet."
                os.write(terminal, b"\x1b[Z")  # Shift-Tab, protocolo xterm.
                # Al volver, Select sitúa el cursor al principio del campo; después
                # de escribir estaba al final. Comparar el campo (fila), no esa columna.
                assert collect_until(lambda: snapshot().get("cursor", [0])[0] == previous[0]), "Shift-Tab no volvió al campo."
            elif completion['server'] == 'vtsls':
                assert snapshot().get('selected') == 'toUpperCase', snapshot()
                os.write(terminal, b'\r')
                assert collect_until(lambda: any(
                    'greeting.toUpperCase()' in line for line in snapshot().get('lines', [])
                )), ('Enter no aceptó el método JS', snapshot())
            else:
                os.write(terminal, b"\x05")  # Ctrl-e: cancelar.
                assert collect_until(lambda: snapshot().get("visible") is False), "Ctrl-e no cerró el menú."
            os.write(terminal, b"\x1b")
        if navigation:
            # Pulsar los atajos en una TUI real, no simularlos solo con llamadas Lua.
            state = base / "navigation-state.json"

            def read_state():
                state.unlink(missing_ok=True)
                command = (
                    ':lua vim.fn.writefile({vim.json.encode({sidebar=require("nvim-tree.api").tree.is_visible(),'
                    'filetype=vim.bo.filetype,relative=vim.wo.relativenumber,tabs=#vim.api.nvim_list_tabpages(),'
                    'windows=#vim.api.nvim_tabpage_list_wins(0),errmsg=vim.v.errmsg})}, '
                    + json.dumps(str(state)) + ")\r"
                )
                os.write(terminal, b"\x1b" + command.encode())
                assert collect_until(state.exists), "No se pudo leer el estado de navegación."
                result = json.loads(state.read_text())
                assert result["errmsg"] == "", result
                return result

            assert read_state()["relative"], "No activó números relativos."
            os.write(terminal, b" e")
            assert collect_until(lambda: b"SIDEBAR_ENTRY.txt" in output), "No dibujó la barra lateral."
            assert read_state()["sidebar"], "Space e no abrió la barra."
            os.write(terminal, b"\x0c")  # Ctrl-l: volver al archivo.
            assert read_state()["filetype"] == "text", "Ctrl-l no volvió al archivo."
            os.write(terminal, b" e")
            assert not read_state()["sidebar"], "Space e no cerró la barra."
            os.write(terminal, b" \t\t")
            assert read_state()["tabs"] == 2, "Space Tab Tab no creó pestaña."
            os.write(terminal, b" \td")
            assert read_state()["tabs"] == 1, "Space Tab d no cerró pestaña."
            os.write(terminal, b" |")
            assert read_state()["windows"] == 2, "Space | no creó split."
            os.write(terminal, b" wd")
            assert read_state()["windows"] == 1, "Space wd no cerró split."
        os.write(terminal, b"\x1b:qa!\r")
        deadline = time.monotonic() + 5
        while time.monotonic() < deadline:
            child, status = os.waitpid(pid, os.WNOHANG)
            if child:
                finished = True
                assert os.waitstatus_to_exitcode(status) == 0, "Neovim no cerró correctamente."
                break
            collect_until(lambda: False, seconds=0.1)
        assert finished, "Neovim no respondió a :qa!."
        assert b"Resource temporarily unavailable" not in output
    finally:
        if not finished:
            # Solo el grupo de procesos creado para esta prueba, nunca instancias del usuario.
            try:
                os.killpg(pid, signal.SIGKILL)
                os.waitpid(pid, 0)
            except ProcessLookupError:
                pass
        os.close(terminal)


def main():
    check_documented_commands()
    data_home = Path(os.environ.get("XDG_DATA_HOME") or Path.home() / ".local/share")
    dependencies = (
        "start/mini.nvim", "opt/nvim-tree.lua", "opt/blink.cmp", "opt/friendly-snippets",
        "opt/nvim-lspconfig", "opt/mason.nvim", "opt/mason-lspconfig.nvim",
    )
    for name in dependencies:
        assert (data_home / "nvim-learning/site/pack/deps" / name).is_dir(), "Primero instalar las dependencias: " + name
    with tempfile.TemporaryDirectory(prefix="nvim-terminal-") as directory:
        base = Path(directory)
        shutil.copytree(ROOT / "learning", base / "config/nvim-learning")
        for name in dependencies:
            shutil.copytree(data_home / "nvim-learning/site/pack/deps" / name,
                            base / "data/nvim-learning/site/pack/deps" / name, symlinks=True)
        # Copiar binarios/registro aislados: la prueba no descarga herramientas nuevas.
        shutil.copytree(data_home / "nvim-learning/mason", base / "data/nvim-learning/mason", symlinks=True)
        environment = os.environ.copy()
        environment.update({
            "TERM": "xterm-256color",
            "XDG_CONFIG_HOME": str(base / "config"),
            "XDG_DATA_HOME": str(base / "data"),
            "XDG_STATE_HOME": str(base / "state"),
            "XDG_CACHE_HOME": str(base / "cache"),
            "NVIM_LOG_FILE": str(base / "nvim.log"),
        })
        check_terminal(base, environment, [], b"[No Name]")
        sample = base / "file with spaces.txt"
        sample.write_text("TERMINAL_RENDER_OK\n")
        (base / "SIDEBAR_ENTRY.txt").write_text("Sidebar fixture\n")
        # El árbol muestra el directorio del ejercicio, no todo el repo durante esta prueba.
        arguments = ["-c", "cd " + str(base), str(sample)]
        check_terminal(base, environment, arguments, b"TERMINAL_RENDER_OK", navigation=True)
        fixtures = (
            ("index.html", "<!-- COMPLETION_FIXTURE -->\n\n", {
                "server": "html", "keys": b"GAhtml5", "label": "html5", "source": "snippets",
            }),
            ("styles.css", "/* COMPLETION_FIXTURE */\nbody {\n  \n}\n", {
                "server": "cssls", "keys": b"3GAcol", "label": "color", "source": "lsp",
            }),
            ("main.js", '// COMPLETION_FIXTURE\nconst greeting = "hello";\n\n', {
                "server": "vtsls", "keys": b"GAgreeting.toU", "label": "toUpperCase", "source": "lsp",
            }),
        )
        for name, content, completion in fixtures:
            sample = base / name
            sample.write_text(content)
            check_terminal(base, environment, ["-c", "cd " + str(base), str(sample)],
                           b"COMPLETION_FIXTURE", completion=completion)
        # Desactivar en la copia temporal: no editar el perfil instalado para la prueba.
        init = base / "config/nvim-learning/init.lua"
        init.write_text(init.read_text().replace("vim.g.learning_web_tools = true", "vim.g.learning_web_tools = false"))
        rollback = subprocess.run([
            "nvim", "--headless", "-n", "-i", "NONE", "-c",
            "lua assert(package.loaded['blink.cmp'] == nil); assert(package.loaded['mason'] == nil); "
            "assert(MiniPick and MiniBufremove); assert(#vim.lsp.get_clients() == 0); assert(vim.v.errmsg == '')",
            "-c", "qa!",
        ], env=environment, cwd=ROOT, capture_output=True, text=True, timeout=20)
        assert rollback.returncode == 0, rollback.stderr
    print("OK: lanzador directo dibuja interfaz, procesa teclado y cierra; argumentos con espacios conservados.")
    print("OK: barra lateral renderizada, relativos, ventanas y pestañas comprobados con atajos reales.")
    print("OK: menú automático HTML/CSS/JS, Enter acepta html5/método JS, Tab/Shift-Tab recorren campos, Ctrl-e cancela.")
    print("OK: reversión por flag conserva MINI sin cargar Blink/Mason ni clientes LSP.")
    print("Pseudoterminal POSIX con datos temporales; no prueba visual de Kitty/Ghostty ni ejecución en Arch.")


if __name__ == "__main__":
    main()
