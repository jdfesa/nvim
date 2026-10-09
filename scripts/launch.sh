#!/bin/sh
# Interactive Launcher
# No envolver la interfaz de Neovim en RTK: necesita acceso directo a la terminal.
# Mantener el nombre solo en este proceso y conservar todos los argumentos.
exec env NVIM_APPNAME=nvim-learning nvim "$@"
