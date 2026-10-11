# Neovim Step by Step with MiniMax

Un entorno propio para aprender Neovim mientras resolvemos ejercicios, con cambios
pequeños y explicados. Sistemas objetivo: **macOS y Arch Linux**.
Primer bloque: **HTML, CSS y JavaScript**.

## Launch

Abrir el perfil educativo instalado, desde cualquier carpeta:

```sh
env NVIM_APPNAME=nvim-learning nvim
```

Volver a LazyVim, sin restaurar ni reinstalar nada:

```sh
env -u NVIM_APPNAME nvim
```

No exportar `NVIM_APPNAME` globalmente. La [guía de lanzamiento](docs/05-launch-and-profiles.md)
explica rutas, comprobación del perfil y regreso al habitual.
**No usar RTK para abrir el editor interactivo.** En la versión local 0.43.0,
`rtk proxy` dejó la pantalla en blanco. RTK se conserva para comandos automatizados
sin interfaz, como las pruebas headless y el instalador. También podés abrir este
perfil con `sh scripts/launch.sh` desde la raíz del repo.

## Current Status

- MiniMax clonado con historial, licencia y remoto oficial `upstream`.
- Referencias originales conservadas en `configs/`, sin modificar su comportamiento.
- Fuente propia en `learning/`: barra lateral, búsqueda, barra de estado y cierre seguro de buffers.
- Números relativos y atajos de práctica compartidos con LazyVim para ventanas y pestañas.
- Perfil `nvim-learning` instalado y probado headless y en pseudoterminal en macOS, Neovim 0.11.4.
- LazyVim intacto, con su enlace y datos habituales; no actualizamos Neovim.
- Sin LSP, parsers adicionales, snippets ni formato automático todavía.
- Arranque visual confirmado por el usuario; práctica de funciones y ejecución real en Arch pendientes.
- Documentación con títulos en inglés y contenido en español.

> La raíz del repo **no es una configuración activa**. Nuestro instalador copia
> `learning/` al perfil educativo. Abrir Neovim aquí no selecciona ese perfil.
> `setup.lua` y `configs/` conservan el generador/referencias originales de MiniMax.

## Getting Started

1. [Launch and Separate Profiles](docs/05-launch-and-profiles.md): abrir y cambiar de perfil.
2. [Learning Profile](docs/06-learning-profile.md): nuestros cinco archivos, opciones y dependencias.
3. [Navigation and Practice Keymaps](docs/07-navigation-and-keymaps.md): activar la barra lateral y practicar.
4. [Roadmap](ROADMAP.md): etapas y criterios para avanzar.
5. [Installation and Isolated Profile](docs/01-installation.md): repetir en macOS/Arch.
6. [File Map](docs/02-file-map.md): fuentes propias y referencias originales.
7. [Configuration Workflow](docs/03-workflow.md): cambios pequeños y organización por lenguaje.
8. [First Language Stack](docs/languages/web.md): HTML, CSS y JavaScript.
9. [Learning Journal](docs/04-journal.md): cambios y verificaciones reales.

Consulta rápida: [Keymaps](KEYMAPS.md), con teclas, modos, alcance y diferencias
con LazyVim. La guía 07 explica los conceptos y propone ejercicios.

El [índice de documentación](docs/README.md) reúne las guías.
Las reglas están en [AGENTS.md](AGENTS.md): nombres en inglés ASCII,
títulos en inglés y contenido en español.

## Install or Refresh

Con Neovim 0.11+ y Git disponibles, desde la raíz del repo:

```sh
rtk proxy env NVIM_APPNAME=nvim-learning nvim --clean -l scripts/install.lua
```

Copia los cinco archivos de `learning/`, verifica cambios locales y respalda
versiones instaladas que reemplaza. No instala plugins ni crea commits. El primer
arranque descarga `mini.nvim` v0.18.0 y `nvim-tree` v1.18.0, con revisiones fijas. `ripgrep`
permite buscar texto con nuestro atajo.

La configuración instalada **es una copia, no un enlace**. Editar `learning/`,
repetir el instalador con el perfil cerrado y reiniciar. No editar solo la copia
si queremos guardar los cambios en GitHub.

## Our Definition of Minimal

Poder explicar lo que activamos y añadir funciones por una necesidad concreta,
no activar todo MINI ni reducir líneas a cualquier precio. Cada cambio debe
explicar **qué resuelve, dónde vive, cómo se prueba y cómo se revierte**.

## Origin and Versions

Base: [nvim-mini/MiniMax](https://github.com/nvim-mini/MiniMax), commit
[`14bd13f20268cc6c8464afedfbe4ab2430f9c353`](https://github.com/nvim-mini/MiniMax/commit/14bd13f20268cc6c8464afedfbe4ab2430f9c353).
Conservamos [README original](README.upstream.md), [CHANGELOG](CHANGELOG.md),
[referencias](configs/README.md) y [licencia MIT](LICENSE).

Las carpetas `configs/nvim-0.10`, `nvim-0.11`, `nvim-0.12` y `nvim-0.13`
son referencias por versión, **no por sistema operativo**. Nuestra fuente
`learning/` es única y usa `mini.deps` para mantener compatibilidad con el Mac
actual. Antes de cambiar el binario elegiremos una versión común con Arch;
no confundir actualizar el editor con actualizar la configuración.

Otras propuestas se conservan como [External References](resources/README.md),
con origen y atribución. No forman parte del perfil educativo ni se instalan.

## Validation

Checks estáticos, sin instalar plugins ni cargar el perfil:

```sh
rtk proxy nvim --headless --clean -l tests/validate.lua
rtk proxy nvim --headless --clean -l tests/install.lua
rtk proxy nvim --headless --clean -l tests/keymaps.lua
```

La prueba de keymaps compara las tablas Global/Sidebar con las definiciones de
`learning/`, usando dependencias simuladas. No ejecuta sus acciones ni prueba la UI.

Después de instalar, prueba de arranque real con archivos temporales:

```sh
rtk proxy env NVIM_APPNAME=nvim-learning nvim --headless -n -i NONE \
  -c 'luafile tests/smoke.lua' -c 'qa!'
```

Esta última prueba sí carga el perfil y puede descargar las dependencias si faltan.
No sustituye usar el editor interactivamente ni probarlo en Arch.

Regresión de terminal interactiva, con Python 3 estándar y dependencias ya instaladas:

```sh
rtk proxy python3 tests/terminal.py
```

Esta prueba crea una pseudoterminal para el lanzador, verifica pantalla y teclado
y usa solo archivos/datos temporales. No es una captura de Kitty o Ghostty.

## Version Control

El repositorio personal es [jdfesa/nvim](https://github.com/jdfesa/nvim).
En esta copia de trabajo, `origin` apunta a ese repositorio y `upstream` al
proyecto original MiniMax; no publicamos cambios propios en `upstream`.
Conservamos su historial y licencia. Al clonar el repo personal en otra máquina,
Git configura `origin`; los demás remotos no se copian automáticamente.

Los commits propios siguen **Conventional Commits**, con mensajes en inglés y
cambios separados por responsabilidad. Las reglas están en [AGENTS.md](AGENTS.md).

[.gitignore](.gitignore) excluye temporales, datos generados y variables privadas;
las fuentes, documentación, scripts, pruebas y lockfiles se conservan. Los plugins
se instalan fuera del repo, en los datos del perfil. Revisar secretos y archivos
ya rastreados antes de publicar: ignorar un archivo no lo elimina del historial.
