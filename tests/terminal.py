"""Interactive Terminal Regression

Comprueba el lanzador en una pseudoterminal POSIX, no en modo headless.
Usa Python estándar, datos temporales y una copia de mini.nvim ya instalada.
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


def check_terminal(base, environment, arguments, expected):
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
    dependency = data_home / "nvim-learning/site/pack/deps/start/mini.nvim"
    assert dependency.is_dir(), "Primero instalar y arrancar nvim-learning para descargar mini.nvim."
    with tempfile.TemporaryDirectory(prefix="nvim-terminal-") as directory:
        base = Path(directory)
        shutil.copytree(ROOT / "learning", base / "config/nvim-learning")
        shutil.copytree(dependency, base / "data/nvim-learning/site/pack/deps/start/mini.nvim", symlinks=True)
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
        check_terminal(base, environment, [str(sample)], b"TERMINAL_RENDER_OK")
    print("OK: lanzador directo dibuja interfaz, procesa teclado y cierra; argumentos con espacios conservados.")
    print("Pseudoterminal POSIX con datos temporales; no prueba visual de Kitty/Ghostty ni ejecución en Arch.")


if __name__ == "__main__":
    main()
