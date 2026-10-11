"""Interactive Terminal Regression

Comprueba el lanzador en una pseudoterminal POSIX, no en modo headless.
Usa Python estándar, datos temporales y copias de las dos dependencias ya instaladas.
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


def check_terminal(base, environment, arguments, expected, navigation=False):
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
    dependencies = ("start/mini.nvim", "opt/nvim-tree.lua")
    for name in dependencies:
        assert (data_home / "nvim-learning/site/pack/deps" / name).is_dir(), "Primero instalar las dependencias: " + name
    with tempfile.TemporaryDirectory(prefix="nvim-terminal-") as directory:
        base = Path(directory)
        shutil.copytree(ROOT / "learning", base / "config/nvim-learning")
        for name in dependencies:
            shutil.copytree(data_home / "nvim-learning/site/pack/deps" / name,
                            base / "data/nvim-learning/site/pack/deps" / name, symlinks=True)
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
    print("OK: lanzador directo dibuja interfaz, procesa teclado y cierra; argumentos con espacios conservados.")
    print("OK: barra lateral renderizada, relativos, ventanas y pestañas comprobados con atajos reales.")
    print("Pseudoterminal POSIX con datos temporales; no prueba visual de Kitty/Ghostty ni ejecución en Arch.")


if __name__ == "__main__":
    main()
