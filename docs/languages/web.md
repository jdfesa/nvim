# First Language Stack - HTML, CSS, and JavaScript

Objetivo: editar una página con estructura HTML, estilos CSS y comportamiento
JavaScript, con **sugerencias automáticas como las del LazyVim de referencia**.
No instalar toda la distribución ni activar frameworks, React, TypeScript,
depurador, linting o formato automático al guardar.

## Need and Decision

El 2026-10-12 el usuario pidió replicar el autocompletado de LazyVim, no limitarse
a un snippet propio. Revisamos su configuración y elegimos el mismo motor
**blink.cmp**, la misma colección **friendly-snippets** y el preset **enter**.
Esto reemplaza la propuesta anterior de usar mini.completion/mini.snippets;
esa propuesta no llegó a activarse. MINI conserva búsqueda, estado y buffers.

El LazyVim observado no tenía servidores HTML/CSS/JavaScript instalados. Por eso
distinguimos **replicar el motor y sus controles** de **incorporar soporte web**:
añadimos tres servidores, con las capas Mason y nvim-lspconfig que usa LazyVim.
Para JavaScript elegimos vtsls, la opción de su extra de TypeScript; el servidor
usa TypeScript internamente, pero aquí solo se adjunta a archivos JavaScript.

## What Each Layer Does

| Layer | Responsibility | Example |
| --- | --- | --- |
| Filetype | Identificar el archivo | `index.html` tiene filetype `html` |
| blink.cmp | Mostrar, ordenar y aceptar sugerencias al escribir | Menú automático y documentación |
| friendly-snippets | Proveer plantillas ya escritas | `html5` genera un documento |
| vim.snippet | Expandir la plantilla y recorrer sus campos | Editar idioma, título y ruta CSS |
| LSP client | Comunicar Neovim con un servidor | Cliente incluido en Neovim |
| Language server | Conocer etiquetas, propiedades y símbolos | CSS `color`; JS `toUpperCase` |
| nvim-lspconfig | Proveer configuraciones de los servidores | Comando, filetype y raíz del proyecto |
| Mason | Instalar ejecutables en los datos del perfil | `html-lsp`, `css-lsp`, `vtsls` |
| mason-lspconfig | Conectar nombres, instalación y activación | `html` corresponde a `html-lsp` |

Las cuatro fuentes de Blink son **lsp**, **path**, **snippets** y **buffer**.
Sin un servidor adjunto todavía puede sugerir plantillas, rutas y palabras;
eso no demuestra que el soporte inteligente del lenguaje esté funcionando.
No es autocompletado con IA ni se envía código a un servicio de IA.

## Files and Load Order

1. `learning/init.lua`: valida Neovim **0.11.3+**, prepara MINI y define
   `vim.g.learning_web_tools = true`.
2. `learning/plugin/30_mini.lua`: mantiene los módulos existentes; no activa
   un segundo motor de completion.
3. `learning/plugin/50_completion.lua`: instala/verifica los dos pins de
   completion y configura Blink. El menú no necesita Nerd Font ni Tree-sitter.
4. `learning/plugin/60_web_lsp.lua`: instala/verifica las tres dependencias LSP,
   prepara Mason, transmite las capacidades de Blink y habilita solo el bloque web.
5. `scripts/install.lua`: copia los siete archivos gestionados al perfil; no
   descarga herramientas. Los plugins se instalan al arrancar el perfil.

Neovim carga `plugin/` en orden alfabético: Blink existe antes de configurar LSP.
No editamos `configs/`, `setup.lua` ni la configuración habitual de LazyVim.
La copia instalada no es la fuente: cambiar `learning/`, reinstalar y reiniciar.

## Dependencies and Pins

| Plugin | Revision | Purpose |
| --- | --- | --- |
| blink.cmp v1.10.2 | `78336bc89ee5365633bcf754d93df01678b5c08f` | Motor del menú |
| friendly-snippets | `6cd7280adead7f586db6fccbd15d2cac7e2188b9` | Colección de plantillas |
| nvim-lspconfig | `d224a1920728ba129880efc700d4a0180ac4ecbb` | Configuración LSP |
| mason.nvim | `2a6940af80375532e5e9e7c1f2fc6319a1b7a69d` | Instalación aislada |
| mason-lspconfig.nvim | `47059d71b42d74b0a1e9f61c1d99d301039c3b5b` | Instalación/activación de servidores |

Son revisiones verificadas en la instalación de referencia, no referencias móviles
a `main`. En particular, el checkout real de mason-lspconfig difería de su lockfile;
elegimos y registramos explícitamente el checkout real. `mini.deps` sigue siendo
nuestro gestor: no agregamos lazy.nvim ni cargamos LazyVim.

| Language | LSP Name | Mason Package | Version |
| --- | --- | --- | --- |
| HTML | `html` | `html-lsp` | `4.10.0` |
| CSS | `cssls` | `css-lsp` | `4.10.0` |
| JavaScript | `vtsls` | `vtsls` | `0.3.0` |

HTML/CSS usan `vscode-langservers-extracted`; vtsls envuelve el soporte JS/TS de
VS Code. Los paquetes pueden traer otros ejecutables como dependencias, pero no
habilitamos sus servidores, linting ni otros lenguajes. Mason instala bajo
`stdpath('data') .. '/mason'`, separado del Mason habitual; no usa `npm -g` global.
Los pins fijan nuevas instalaciones, **no actualizan automáticamente paquetes ya
instalados**. Los receipts registran lo instalado; fijar estos paquetes principales
no equivale a un lockfile de todas sus dependencias transitivas. Antes de cambiar
una versión, revisar su receipt y probar otra vez.

## Prepare and Install

Necesitamos Git, **Node.js/npm**, curl y utilidades de extracción, además de
Neovim 0.11.3+. En macOS ya estaban Node 22.20.0/npm 10.9.3 mediante nvm; no
instalamos ni actualizamos esos ejecutables. Para repetir, usar el gestor habitual
del sistema (por ejemplo Homebrew en macOS o paquetes nodejs/npm en Arch) y comprobar:

```sh
node --version
npm --version
```

Abrir Neovim desde una terminal que tenga esos ejecutables en `PATH`. El navegador
sigue siendo el runtime de los ejercicios; Node es una dependencia de las herramientas.
Blink descarga y verifica el binario precompilado de v1.10.2 para la plataforma;
no exige instalar Rust. Si no puede obtenerlo, avisa y puede usar su implementación Lua.

Con el perfil educativo cerrado, desde la raíz del repo:

```sh
rtk proxy env NVIM_APPNAME=nvim-learning nvim --clean -l scripts/install.lua
env NVIM_APPNAME=nvim-learning nvim index.html
```

El primer arranque requiere red y puede tardar: descarga plugins, registro y
servidores. Consultar `:Mason` para esperar que finalicen los tres paquetes.
En esta revisión, `ensure_installed` **no instala servidores en modo headless**.
Para preparar una máquina mediante una ejecución automatizada, instalarlos
explícitamente con este comando dentro del perfil:

```vim
:MasonInstall html-lsp@4.10.0 css-lsp@4.10.0 vtsls@0.3.0
```

Después, reabrir el archivo si el servidor no se adjuntó durante la instalación.
No exportar `NVIM_APPNAME` globalmente ni lanzar la TUI detrás de RTK.

## First Practice

### HTML Template

1. Abrir un `index.html` vacío; comprobar `:set filetype?` → `html`.
2. Entrar en Insert con `i` y escribir **`html5`**.
3. El menú debe aparecer solo. Elegir la plantilla si hace falta con `Ctrl-n` /
   `Ctrl-p` y aceptar con `Enter`; `Ctrl-y` selecciona y acepta directamente.
4. Cambiar el idioma de `en` a `es`; usar `Tab` para título y ruta CSS, y
   `Shift-Tab` para volver. Al final se llega al cuerpo del documento.
5. Ajustar la ruta de la plantilla: trae `css/style.css`, pero nuestro ejercicio
   puede usar `styles.css`. Agregar `main.js` a mano cuando el ejercicio lo requiera.

Conservamos la plantilla de terceros sin traducirla ni sustituirla. Su `html5`
viene de friendly-snippets; **no instalamos Emmet**. `ul>li*3` no debe documentarse
como una expansión activa de este perfil.

### Language Suggestions

- **HTML:** escribir `<di` y buscar la etiqueta `div`.
- **CSS:** dentro de `body { ... }`, escribir `col` y buscar `color`.
- **JavaScript:** escribir `const greeting = "hello";` y, en otra línea,
  `greeting.toU`; buscar `toUpperCase`.

Estas sugerencias deben venir de la fuente **LSP**, no solo de una palabra que ya
existe en el buffer. Revisar los clientes con:

```vim
:checkhealth vim.lsp
:lua vim.print(vim.lsp.get_clients({ bufnr = 0 }))
```

Los atajos, modos y alcances están exclusivamente en [KEYMAPS.md](../../KEYMAPS.md).
La documentación flotante aparece tras 200 ms. `Enter` acepta la selección;
`Tab` recorre campos, no acepta candidatos del menú.

## Differences from Full LazyVim

Mismo motor, colección, fuentes, preset de aceptación y ayuda de documentación;
no prometemos equivalencia completa con la distribución. Conservamos mini.deps,
habamax, buscador MINI y nuestra barra lateral. El menú muestra texto en vez de
iconos; no necesita parsers, Nerd Font, Snacks ni ayudantes internos de LazyVim.
Usamos vim.snippet directamente, no su wrapper de corrección de snippets.
No copiamos atajos de refactorización, inlay hints, IA ni formato al guardar.

## Troubleshooting and Rollback

- Sin menú: confirmar perfil/copia instalada, filetype y `:messages`.
- Sin fuente LSP: esperar `:Mason`, comprobar Node/npm en PATH y consultar
  `:MasonLog` / `:checkhealth vim.lsp`.
- Sin estructura completa: aceptar el snippet; seleccionar no equivale a expandir.
- `Ctrl-Space` interceptado por macOS: usar el menú automático y `Ctrl-n`/`Ctrl-p`.
- Pin de plugin incorrecto: no hacer un reset ciego; revisar cambios/revisión y
  resolver antes de actualizar. `MiniDeps.add` no corrige un checkout existente.

Para desactivar esta incorporación sin borrar datos, cambiar
`vim.g.learning_web_tools = false` en `learning/init.lua`, reinstalar y reiniciar.
Los dos archivos nuevos retornan antes de cargar sus dependencias; navegación y
MINI siguen activos. No borrar todo `nvim-learning`: también contiene undo y otros
datos. Los respaldos del instalador sirven como referencia, no se copian a ciegas
porque sus hashes deben mantenerse coherentes.

## Validation and Next Steps

Pruebas estáticas e instalador: `tests/validate.lua`, `tests/install.lua` y
`tests/keymaps.lua`. Integración real, con las dependencias ya instaladas:

```sh
rtk proxy env NVIM_APPNAME=nvim-learning nvim --headless -n -i NONE \
  -c 'luafile tests/web-completion.lua' -c 'qa!'
rtk proxy python3 tests/terminal.py
```

La integración comprueba versiones, mapas reales y respuestas LSP de los tres
lenguajes; la pseudoterminal comprueba el menú al escribir y la expansión por teclado.
No equivalen a una inspección visual en Kitty/Ghostty ni a ejecutar en Arch.
Resultados reales en la [bitácora](../04-journal.md).

Sigue pendiente completar un ejercicio en el navegador, repetir en Arch y añadir
parsers, formatter o linter solo cuando aparezca una necesidad concreta.

## References

- [LazyVim: Blink](https://www.lazyvim.org/extras/coding/blink).
- [LazyVim: TypeScript and vtsls](https://www.lazyvim.org/extras/lang/typescript).
- [Blink v1.10.2](https://github.com/saghen/blink.cmp/tree/v1.10.2).
- [friendly-snippets HTML at the selected pin](https://github.com/rafamadriz/friendly-snippets/blob/6cd7280adead7f586db6fccbd15d2cac7e2188b9/snippets/html.json).
- [Mason](https://github.com/mason-org/mason.nvim) y [mason-lspconfig](https://github.com/mason-org/mason-lspconfig.nvim).
- [vscode-langservers-extracted](https://github.com/hrsh7th/vscode-langservers-extracted) y [vtsls](https://github.com/yioneko/vtsls).
