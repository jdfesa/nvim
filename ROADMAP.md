# Roadmap: Learning Neovim with MiniMax

## Goal and Principles

Trabajar con HTML, CSS y JavaScript en **macOS y Arch Linux**, comprendiendo cada
archivo. Primero explicar, después activar y comprobar. Una etapa a la vez.

- Separar el perfil de aprendizaje mediante `NVIM_APPNAME`.
- Elegir la misma versión estable del editor en ambos sistemas para el uso diario.
- Compartir Lua; documentar diferencias reales de instalación y portapapeles.
- Añadir funciones por necesidad, con prueba y reversión.
- Distinguir «fuente preparada», «instalado» y «probado».
- Aplicar [AGENTS.md](AGENTS.md): nombres en inglés ASCII, títulos en inglés y
  contenido en español.

## 0. Repository Setup - Completed

- [x] Clonar MiniMax, conservar historial, licencia y remoto `upstream`.
- [x] Conservar referencias originales y README del proyecto de origen.
- [x] Crear `docs/`, explicar archivos y flujo de carga.
- [x] Definir HTML, CSS y JavaScript como primer bloque.
- [x] Añadir validación estática sin instalación de plugins.
- [x] Definir el repositorio público personal y Conventional Commits en inglés.

**Resultado:** podemos estudiar la base sin alterar el editor habitual.

## 1. Editor and Isolated Profile Setup - In Progress

- [ ] Confirmar terminal, versión de macOS y sesión Wayland/X11 en Arch.
- [ ] Elegir y verificar la misma versión estable de Neovim en ambos sistemas.
- [x] Revisar dependencias: Neovim 0.11+, Git y ripgrep; una dependencia MINI fijada.
- [x] Instalar `nvim-learning` y comprobar rutas separadas de LazyVim en macOS.
- [x] Definir `learning/` como fuente y el instalador protegido para copiar cambios.
- [x] Comprobar el arranque del perfil recortado y edición de archivos en macOS headless.
- [ ] Repetir la preparación en Arch; registrar versiones y limitaciones.

**Estado:** Mac usa 0.11.4 sin actualizar; perfil recortado instalado y probado
headless/PTY y con arranque visual confirmado, sin afectar dotfiles. Falta versión
común, práctica interactiva completa y Arch.
Guía: [instalación](docs/01-installation.md).

## 2. Basics and MiniMax Simplification

- [ ] Leer juntos `init.lua` y sus helpers de carga.
- [ ] Revisar `10_options.lua`: números, búsqueda, indentación, splits y undo.
- [ ] Revisar `20_keymaps.lua`: modos, Leader y pocos atajos cotidianos.
- [x] Conservar inicialmente explorador, búsqueda y barra de estado.
- [ ] Evaluar autocompletado y ayuda de atajos antes de decidir qué mantener.
- [x] Posponer sesiones, dashboard, snippets y extras que no necesitemos.
- [x] Dejar solo atajos para módulos activos y funciones nativas.
- [x] Arrancar el perfil recortado y abrir/guardar HTML/CSS/JavaScript en pruebas temporales.
- [x] Probar el lanzador directo en pseudoterminal: pantalla, teclado y cierre; sin RTK en la TUI.
- [ ] Revisar `:checkhealth` y usar el perfil interactivamente.
- [ ] Comprobar el mismo perfil mínimo en macOS y Arch.
- [ ] Practicar buffers, ventanas, búsqueda, copiar/pegar y lectura de ayuda.

**Criterio de avance:** entendemos lo activo y no hay atajos que llamen módulos
desactivados. No necesitamos aprender todos los atajos upstream.
Guía: [mapa de archivos](docs/02-file-map.md).

## 3. First Language Stack: HTML, CSS, and JavaScript

- [ ] Detectar los tres filetypes y añadir opciones locales solo si hacen falta.
- [ ] Crear un ejercicio pequeño y probarlo en el navegador.
- [ ] Diferenciar editor, runtime, LSP, parser, formatter y linter.
- [ ] Elegir servidores LSP de uno en uno; comprobar que se adjuntan.
- [ ] Añadir parsers Tree-sitter web y verificar resaltado.
- [ ] Elegir formatter; comenzar con formato manual, no al guardar.
- [ ] Añadir linting solo ante una necesidad concreta.
- [ ] Repetir las pruebas de edición/herramientas en macOS y Arch.

**Criterio de avance:** editamos y ejecutamos ejercicios y entendemos qué aporta
cada mejora. Sin React, TypeScript ni depurador en esta etapa.
Guía: [bloque web](docs/languages/web.md).

## 4. Reproducibility and Maintenance

- [ ] Guardar revisiones: lockfile en 0.12+ o snapshot de `mini.deps` en 0.11.
- [ ] Documentar actualización y reversión de editor, plugins y configuración por separado.
- [ ] Reconstruir desde una copia limpia en ambos sistemas.
- [ ] Registrar dependencias y comportamientos específicos del OS.
- [x] Definir `origin` en [jdfesa/nvim](https://github.com/jdfesa/nvim), sin publicar en `upstream`.

**Criterio de avance:** reconstruimos el entorno sin depender de archivos locales
no registrados.

## 5. Additional Languages - On Demand

- [ ] Elegir el siguiente lenguaje según los ejercicios.
- [ ] Crear su guía, con dependencias, prueba y reversión.
- [ ] Añadir opciones/servidor/herramientas sin mezclar responsabilidades.
- [ ] Validar macOS y Arch antes de dar por terminada la integración.

No hay otros lenguajes preseleccionados ni herramientas instaladas para ellos.

## Current Validation

| Entorno | Estado |
| --- | --- |
| macOS, Neovim 0.11.4 | Headless/PTY probados y arranque visual confirmado; práctica completa de funciones pendiente |
| Arch Linux | Instrucciones preparadas; prueba real pendiente |
| Neovim 0.12+ | Referencias conservadas; prueba real pendiente |

Ver resultados y límites en la [bitácora](docs/04-journal.md).
