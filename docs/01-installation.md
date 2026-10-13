# 01 - Installation and Isolated Profile

## Current State

El perfil educativo está instalado y probado headless y en pseudoterminal en el Mac observado:
Neovim `0.11.4`, Git y ripgrep `14.1.1` disponibles. No instalamos paquetes con
Homebrew ni actualizamos el editor. El usuario confirmó el arranque visual con el
comando directo; práctica de funciones y ejecución real en Arch quedan pendientes.

`/Users/jd/.config/nvim` sigue enlazando a `/Users/jd/mydotfiles/shared/nvim`.
El perfil nuevo está en `/Users/jd/.config/nvim-learning`; no sustituir ese enlace.

## Requirements

Nuestro perfil necesita **Neovim 0.11.3+ y Git**. `ripgrep` habilita la búsqueda de
texto. El autocompletado web incorporado necesita **Node.js/npm**, curl y
utilidades de extracción para Mason. No exigimos compilador, Tree-sitter CLI ni
Nerd Font; Python 3 solo se usa para nuestras pruebas PTY. Ver dependencias,
versiones y proceso en [Web Completion](languages/web.md).

```sh
rtk proxy nvim --version
rtk git --version
rtk proxy rg --version
```

Los siguientes comandos de paquetes son para otra máquina o dependencias faltantes,
no acciones ya ejecutadas. Revisar antes de cambiar el binario: también lo usa LazyVim.

### macOS

Si faltan las herramientas básicas:

```sh
rtk proxy brew install neovim git ripgrep
```

No fijar `/usr/local` ni `/opt/homebrew` dentro del Lua compartido. Las versiones
instaladas pueden variar; comprobarlas y probar ambas configuraciones si actualizás
el editor. Homebrew puede actualizar dependencias durante una instalación.

### Arch Linux

Instalación acompañada de actualización completa del sistema:

```sh
rtk proxy sudo pacman -Syu --needed neovim git ripgrep
```

`-Syu` también actualiza el sistema: leer la transacción antes de confirmarla.
No hacer actualizaciones parciales. Compartimos la misma fuente `learning/`, no
creamos otra configuración por OS. La prueba real en Arch todavía no se realizó.

### Clipboard and Terminal

| Entorno | Qué revisar cuando configuremos portapapeles |
| --- | --- |
| macOS | `pbcopy`/`pbpaste` |
| Arch, Wayland | Proveedor habitual: `wl-clipboard` |
| Arch, X11 | Proveedor habitual: `xclip` o `xsel` |
| SSH/tmux | Comprobar la sesión concreta |

No instalamos estos proveedores en esta etapa. Los iconos especiales están
desactivados; usar una terminal con colores reales para el tema incluido.

## Install the Learning Profile

Desde la raíz del repo, revisar el destino primero:

```sh
rtk proxy env NVIM_APPNAME=nvim-learning nvim --headless --clean \
  -c 'lua print(vim.fn.stdpath("config")); print(vim.fn.stdpath("data"))' -c 'qa!'
```

Sin XDG personalizados, la configuración es `$HOME/.config/nvim-learning` en
macOS/Arch. Si esa carpeta ya pertenece a otro entorno, **detenerse**.

```sh
rtk proxy env NVIM_APPNAME=nvim-learning nvim --clean -l scripts/install.lua
```

El instalador propio requiere ese nombre exacto y rechaza destinos ajenos o enlaces
simbólicos en el destino y sus archivos gestionados. Copia siete archivos y crea
`.nvim-learning.json` con sus hashes. No carga el init, no descarga plugins y no hace
`git init`, commits ni cambios de remotos.

Al repetirlo, no cambia archivos idénticos. Si una copia instalada tiene cambios
locales distintos, se detiene antes de escribir: trasladarlos a la fuente y revisar
antes de reintentar. Las fuentes nuevas reemplazan versiones gestionadas con respaldo
en `learning-backup/<timestamp>-<pid>/`. No borra archivos ajenos.

Mantener `learning/` como fuente canónica; al añadir otro archivo, actualizar también
la lista gestionada de `scripts/install.lua` y sus pruebas. La copia no se sincroniza sola.

## First Launch

```sh
env NVIM_APPNAME=nvim-learning nvim
```

Este arranque carga nuestra configuración y descarga los siete plugins fijados si faltan;
Mason instala los tres servidores web dentro de los datos del perfil. El primer
arranque necesita red y puede tardar; revisar `:Mason` antes de probar sugerencias.
Después puede editar/completar sin red mientras plugins, binario de Blink y
servidores ya estén instalados. Las actualizaciones del registro de Mason sí usan red.
Lanzarlo directamente: no usar `rtk proxy` para la interfaz interactiva. Los
comandos automatizados anteriores sí pueden usar RTK.
Dentro del editor:

```vim
:echo stdpath('config')
:echo stdpath('data')
:checkhealth
```

Resolver avisos de funciones usadas, no instalar proveedores opcionales solo para
silenciar warnings. Lanzamiento y retorno a LazyVim en [Launch and Separate Profiles](05-launch-and-profiles.md).
La barra se activa con `Espacio → e`; ver [Navigation and Practice Keymaps](07-navigation-and-keymaps.md).

## Upstream Generator

`setup.lua` sigue siendo el generador original de MiniMax, que selecciona una
referencia completa por versión, respalda conflictos en `MiniMax-backup` y puede
crear repositorio/commit en el destino. **No lo usamos para instalar nuestro perfil
recortado.** Se conserva para estudio y comparación, junto con `configs/`.

## Sources

- [Instalación oficial de Neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md).
- [Neovim en Homebrew](https://formulae.brew.sh/formula/neovim).
- [Neovim en Arch](https://archlinux.org/packages/extra/x86_64/neovim/).
- [Nuestro instalador](../scripts/install.lua) y [guía original MiniMax](../README.upstream.md).
