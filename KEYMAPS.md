# Keymaps

Referencia rápida del perfil **`nvim-learning`**. Incluye las asignaciones que
configuramos, una selección de controles del buscador y comandos nativos para
practicar. No describe el perfil habitual de LazyVim ni las plantillas `configs/`.

[Neovim](https://neovim.io/doc/user/map/) usa **mappings** y
[LazyVim](https://www.lazyvim.org/keymaps) llama **Keymaps** a su referencia de teclas.
`KEYMAPS.md` es nuestra convención documental, no un nombre obligatorio de Neovim.
Los conceptos y ejercicios están en [Navigation and Practice Keymaps](docs/07-navigation-and-keymaps.md).

## Quick Start

Desde la carpeta del ejercicio, abrir el perfil educativo:

```sh
env NVIM_APPNAME=nvim-learning nvim
```

Empezá con cuatro acciones en modo **Normal**, después de pulsar `Esc`:

1. **Toggle Sidebar**: `Espacio → e`.
2. **Find Files**: `Espacio → f → f`.
3. **Switch Window**: `Ctrl-h` / `Ctrl-l` para ir a la izquierda / derecha.
4. **New Tab**: `Espacio → Tab → Tab`.

El archivo es de consulta: no hace falta memorizarlo entero. No activa funciones
por sí mismo ni requiere reinstalar el perfil cuando solo cambia la documentación.

## Key Notation

| Notation | Meaning | Example |
| --- | --- | --- |
| `<Leader>` | Espacio en este perfil; soltarlo y seguir la secuencia | `<Leader>ff` = `Espacio → f → f` |
| `<C-h>` | Mantener Ctrl y pulsar h | No es Command-h en macOS |
| `<S-h>` | Mantener Shift y pulsar h: `H` mayúscula | `<S-l>` = `L` |
| `<CR>` | Enter | Confirmar una selección |
| `<Esc>` | Escape | Salir de Insertar/Visual o cancelar |
| `<Tab>` | La tecla física de tabulación | `<Leader><Tab>]` = `Espacio → Tab → ]` |
| `[` / `]` / `-` / `\|` | El símbolo literal, según la distribución del teclado | `<Leader>\|` crea un split a la derecha |

`uL` y `uw` son distintos: la `L` mayúscula importa. Los prefijos `f`, `s`, `b`,
`w` y `u` ayudan a recordar **files**, **search**, **buffers**, **windows** y **UI**;
no son comandos independientes que haya que ejecutar primero.

### Modes and Scope

| Mode | Meaning |
| --- | --- |
| `n` | **Normal**: navegar y ejecutar acciones |
| `i` | **Insert**: escribir texto |
| `x` | **Visual**: seleccionar texto; no incluye Select mode |
| `s` | **Select**: reemplazar un campo seleccionado de una plantilla |
| `c` | **Command-line**: escribir después de `:`, `/` o `?` |

**Global** significa que el mapa está definido para todo el perfil, en los modos
indicados. La acción puede necesitar un buffer editable. **Sidebar** significa que
solo funciona con el cursor dentro del árbol. Los controles de **Picker** se
procesan aparte mientras el buscador está abierto; no heredan los mapas globales.
**Completion** son mapas locales de blink.cmp, instalados al entrar en Insert en
un buffer editable; **Commandline** corresponde a su integración con la línea de
comandos. No cambian los atajos de navegación en Normal.

## Completion and Snippets

Motor **blink.cmp v1.10.2**, colección **friendly-snippets** y preset `enter`, como
el LazyVim tomado de referencia. El menú aparece al escribir; las fuentes son
LSP, rutas, snippets y palabras de buffers. Guía y ejercicios:
[Web Completion](docs/languages/web.md).

| Key | Action | Mode | Scope |
| --- | --- | --- | --- |
| `<CR>` | Accept Selected / New Line Fallback | i | Completion |
| `<C-y>` | Select and Accept | i | Completion |
| `<C-Space>` | Show Menu / Toggle Documentation | i | Completion |
| `<C-n>` | Select Next / Native Fallback | i | Completion |
| `<C-p>` | Select Previous / Native Fallback | i | Completion |
| `<Down>` | Select Next / Cursor Fallback | i | Completion |
| `<Up>` | Select Previous / Cursor Fallback | i | Completion |
| `<C-e>` | Cancel / Native Fallback | i | Completion |
| `<Tab>` | Next Snippet Field / Tab Fallback | i, s | Completion |
| `<S-Tab>` | Previous Snippet Field / Native Fallback | i, s | Completion |
| `<C-b>` | Scroll Documentation Up / Native Fallback | i | Completion |
| `<C-f>` | Scroll Documentation Down / Native Fallback | i | Completion |
| `<C-k>` | Signature Toggle / Native Fallback | i, s | Completion |

`Enter` acepta **un candidato seleccionado**; si no hay selección, conserva el
salto de línea. `Ctrl-y` puede seleccionar y aceptar directamente. `Tab` no es
nuestro botón para aceptar sugerencias: recorre campos de un snippet activo.
`fallback` significa usar el comportamiento anterior si la acción no aplica.
La ventana de firmas de Blink sigue desactivada, como en su configuración base;
por eso `Ctrl-k` usa el fallback. No prometemos todos los mapas LSP de LazyVim.
`Ctrl-Space` puede ser interceptado por macOS/terminal; el menú automático sigue
funcionando y permite elegir con `Ctrl-n`/`Ctrl-p`.

### Command-line Completion

En `:` el menú aparece automáticamente; en búsquedas `/` y `?` se invoca con
`Ctrl-Space` o `Tab`. Las flechas izquierda/derecha siguen moviendo el cursor.

| Key | Action | Mode | Scope |
| --- | --- | --- | --- |
| `<Tab>` | Show / Insert Single / Select Next | c | Commandline |
| `<S-Tab>` | Show / Insert Single / Select Previous | c | Commandline |
| `<C-Space>` | Show Menu / Native Fallback | c | Commandline |
| `<C-n>` | Select Next / Native Fallback | c | Commandline |
| `<C-p>` | Select Previous / Native Fallback | c | Commandline |
| `<C-y>` | Select and Accept / Native Fallback | c | Commandline |
| `<C-e>` | Cancel / Native Fallback | c | Commandline |
| `<End>` | Hide Menu / Native Fallback | c | Commandline |

Los comandos de consulta son `:Mason`, `:MasonLog` y `:checkhealth vim.lsp`.
No añadimos todavía sus atajos de LazyVim ni mapas de refactorización.

## Files and Search

| Key | Action | Mode | Scope |
| --- | --- | --- | --- |
| `<Leader>e` | Abrir/cerrar la barra lateral | n | Global |
| `<Leader>fe` | Abrir/cerrar la barra lateral; alias de e | n | Global |
| `<Leader>ff` | Buscar archivos en el directorio de trabajo | n | Global |
| `<Leader>fn` | Crear buffer vacío; nombrarlo después con `:w nombre` | n | Global |
| `<Leader>sg` | Buscar texto en el directorio de trabajo; requiere `rg` | n | Global |
| `<Leader>fg` | Buscar texto; alias anterior, distinto de LazyVim | n | Global |
| `<Leader>sh` | Buscar páginas de ayuda | n | Global |
| `<Leader>fh` | Buscar ayuda; alias anterior | n | Global |
| `<Esc>` | Quitar resaltado de búsqueda en Normal | n | Global |
| `<C-s>` | Guardar el buffer y volver a Normal | n, i, x | Global |
| `<Leader>qq` | Salir de todas las ventanas, sin forzar pérdida de cambios | n | Global |

Para un buffer sin nombre, primero usá `:w index.html`. `Ctrl-s` guarda el archivo
completo, no solo una selección. No funciona como guardado dentro del picker.

## Buffers

Un **buffer** es el contenido de un archivo abierto, aunque no esté visible.

| Key | Action | Mode | Scope |
| --- | --- | --- | --- |
| `<Leader>fb` | Elegir un buffer abierto | n | Global |
| `<Leader>,` | Elegir un buffer abierto; alias de fb | n | Global |
| `<S-h>` | Ir al buffer anterior | n | Global |
| `<S-l>` | Ir al buffer siguiente | n | Global |
| `[b` | Ir al buffer anterior; alias de H | n | Global |
| `]b` | Ir al buffer siguiente; alias de L | n | Global |
| `<Leader>bb` | Volver al buffer alternativo | n | Global |
| `<Leader>bd` | Cerrar buffer editable sin destruir la distribución de ventanas | n | Global |

`bd` **no borra el archivo del disco**. Pide confirmación si faltó guardar.
Para cerrar la barra lateral usá su `q`, no `bd`.

## Windows

Una **window** muestra un buffer. Un **split** divide la vista en varias ventanas.

| Key | Action | Mode | Scope |
| --- | --- | --- | --- |
| `<C-h>` | Enfocar la ventana de la izquierda | n | Global |
| `<C-j>` | Enfocar la ventana inferior | n | Global |
| `<C-k>` | Enfocar la ventana superior | n | Global |
| `<C-l>` | Enfocar la ventana de la derecha | n | Global |
| `<Leader>-` | Crear split debajo | n | Global |
| `<Leader>\|` | Crear split a la derecha | n | Global |
| `<Leader>wd` | Cerrar ventana; no necesariamente cerrar su buffer | n | Global |

El split muestra inicialmente el mismo buffer. Desde la ventana nueva podés
elegir otro archivo con la barra o `<Leader>ff`. Ctrl-h/j/k/l también permiten
moverse entre la barra lateral y las ventanas del editor, pero no desde el picker.

## Tab Pages

Una **tab page** es una distribución de ventanas, no un archivo individual.
La barra nativa de pestañas aparece cuando hay más de una.

| Key | Action | Mode | Scope |
| --- | --- | --- | --- |
| `<Leader><Tab><Tab>` | Crear pestaña con buffer vacío | n | Global |
| `<Leader><Tab>]` | Ir a la pestaña siguiente | n | Global |
| `<Leader><Tab>[` | Ir a la pestaña anterior | n | Global |
| `<Leader><Tab>f` | Ir a la primera pestaña | n | Global |
| `<Leader><Tab>l` | Ir a la última pestaña | n | Global |
| `<Leader><Tab>d` | Cerrar pestaña, sin forzar pérdida de cambios | n | Global |

Si solo queda una, el atajo de cierre avisa y la conserva. Para salir usá `:q`
o `<Leader>qq`; para cerrar el archivo usá `<Leader>bd`.

## Display Toggles

| Key | Action | Mode | Scope |
| --- | --- | --- | --- |
| `<Leader>uL` | Alternar números relativos en la ventana actual | n | Global |
| `<Leader>uw` | Alternar ajuste visual de líneas largas en la ventana actual | n | Global |

Los números relativos están activados inicialmente. `uw` cambia la visualización,
no introduce saltos de línea en el archivo. Ver [Relative Numbers](docs/07-navigation-and-keymaps.md#relative-numbers).

## Sidebar

Controles de **nvim-tree**, solo con el cursor dentro de la barra lateral:

| Key | Action | Mode | Scope |
| --- | --- | --- | --- |
| `<CR>` | Abrir archivo o expandir/cerrar carpeta | n | Sidebar |
| `l` | Abrir archivo o expandir/cerrar carpeta; alias de Enter | n | Sidebar |
| `h` | Cerrar carpeta y volver hacia su padre | n | Sidebar |
| `q` | Cerrar solo la barra lateral | n | Sidebar |
| `g?` | Mostrar las asignaciones locales de la barra | n | Sidebar |
| `R` | Refrescar el árbol, especialmente después de cambios externos | n | Sidebar |
| `a` | Crear archivo; terminar el nombre en `/` para crear carpeta | n | Sidebar |
| `<C-v>` | Abrir el archivo seleccionado en split vertical | n | Sidebar |
| `<C-x>` | Abrir el archivo seleccionado en split horizontal | n | Sidebar |
| `<C-t>` | Abrir el archivo seleccionado en pestaña nueva | n | Sidebar |

`j` y `k` mantienen la navegación nativa. No asignamos borrado ni renombrado de
archivos. Solo habilitamos esta selección de mapas, no todos los defaults del plugin.

## Picker

**mini.pick** permite filtrar archivos, buffers, texto o ayuda. Escribir letras
filtra resultados: `j` y `k` aquí escriben la búsqueda, no mueven el cursor.
Estos son controles predeterminados de la versión fijada, no mapas propios:

| Key | Action |
| --- | --- |
| `<C-n>` / `<Down>` | Elegir el resultado siguiente |
| `<C-p>` / `<Up>` | Elegir el resultado anterior |
| `<CR>` | Abrir el resultado seleccionado |
| `<Esc>` | Cancelar el buscador |
| `<Tab>` | Mostrar/ocultar preview: vista previa |
| `<S-Tab>` | Mostrar/ocultar información con todos los controles del picker |
| `<C-s>` | Abrir el resultado en split horizontal; **no guardar** |
| `<C-v>` | Abrir el resultado en split vertical |
| `<C-t>` | Abrir el resultado en pestaña nueva |

Ayuda completa: `:help MiniPick`. Cerrá o confirmá el picker antes de usar los
atajos globales para cambiar de ventana.

## Native Basics

Estos comandos son de Neovim, **no asignaciones añadidas por el perfil**. Usalos
en un buffer editable; algunos plugins reemplazan teclas dentro de sus ventanas.

| Key or Command | Action |
| --- | --- |
| `h` / `j` / `k` / `l` | En Normal: izquierda / abajo / arriba / derecha |
| `5j` / `5k` | En Normal: bajar/subir cinco líneas usando un count |
| `i` / `<Esc>` | Entrar en Insert / volver a Normal |
| `v` | Entrar en Visual para seleccionar |
| `u` / `<C-r>` | En Normal: deshacer / rehacer |
| `:w nombre` | Guardar y asignar nombre al archivo |
| `:q` | Cerrar la ventana actual, con protección de cambios sin guardar |

Los comandos que empiezan con `:` se escriben desde Normal y se confirman con Enter.

## LazyVim Compatibility

Compartimos varias teclas por su intención, **no toda la distribución**. Revisión
de la [referencia oficial](https://www.lazyvim.org/keymaps): **2026-10-11**;
puede cambiar en versiones posteriores.

- Archivos, buffers, ventanas, pestañas y toggles siguen un subconjunto de sus
  teclas. Aquí usamos nvim-tree y mini.pick, no sus mismos plugins.
- `<Leader>e`, `<Leader>fe`, `<Leader>ff` y `<Leader>sg` trabajan aquí sobre el
  directorio actual; LazyVim distingue raíz del proyecto y directorio actual.
- `<Leader>fg` aquí es un alias anterior de búsqueda de **texto**; en LazyVim
  busca **archivos Git**. Practicá `<Leader>sg` para evitar esa diferencia.
- `<Leader>fh` se conserva como alias anterior. Preferí `<Leader>sh` para ayuda.
- Los controles internos de Sidebar y Picker son propios de nuestros plugins.
  No hay menú which-key ni todos los atajos semánticos de LazyVim.
- Desde **2026-10-12**, completion sí usa Blink/friendly-snippets con el preset
  `enter` de LazyVim. La incorporación LSP se limita a HTML/CSS/JavaScript;
  no importa la distribución completa. Diferencias en [Web Completion](docs/languages/web.md).

## Source and Maintenance

- [20_keymaps.lua](learning/plugin/20_keymaps.lua): mapas globales; `<Leader>` se
  define en [init.lua](learning/init.lua) antes de cargarlos.
- [40_sidebar.lua](learning/plugin/40_sidebar.lua): mapas locales de nvim-tree.
- [30_mini.lua](learning/plugin/30_mini.lua): activa mini.pick con sus defaults.
- [10_options.lua](learning/plugin/10_options.lua): opciones iniciales de visualización.
- [50_completion.lua](learning/plugin/50_completion.lua): fuentes y presets Blink.
- [60_web_lsp.lua](learning/plugin/60_web_lsp.lua): servidores y Mason aislado.

El código es la fuente de verdad. Al agregar, cambiar o retirar componentes,
actualizar esta referencia y sus enlaces en el mismo cambio. Los ejercicios van
en la guía 07, no en otra tabla duplicada. Para comprobar teclas, modos y alcance:

```sh
rtk proxy nvim --headless --clean -l tests/keymaps.lua
```

Esta prueba compara los mapas propios y los presets fijados con las tablas
Global/Sidebar/Completion/Commandline, usando dependencias simuladas sin descargarlas.
`tests/web-completion.lua` también compara los mapas reales de Blink con esta
referencia. La prueba estática no prueba acciones, controles internos
del picker ni renderizado: para cambios funcionales también
usar smoke y PTY.

### Inspect Active Keymaps

Desde Normal, podés consultar lo que realmente cargó el editor:

```vim
:verbose nmap <Space>e
:verbose imap <C-s>
```

`nmap` consulta Normal; `imap`, Insert. `verbose` añade información sobre dónde
se definió el mapa. Dentro de la barra, `:nmap <buffer>` lista sus mapas locales.
Si no aparece un mapa esperado, comprobá que abriste `nvim-learning` y que la
copia instalada está actualizada; modificar la fuente no actualiza esa copia solo.

## References

- [Neovim: Key mapping](https://neovim.io/doc/user/map/): términos, modos y alcance.
- [Neovim: Keycodes](https://neovim.io/doc/user/intro/#key-notation): notación de teclas.
- [Neovim: vim.keymap.set](https://neovim.io/doc/user/lua/#vim.keymap.set()): API Lua.
- [LazyVim: Keymaps](https://www.lazyvim.org/keymaps): referencia de teclas y modos.
- [LazyVim: General Settings](https://www.lazyvim.org/configuration/general): `keymaps.lua`.
- [mini.pick v0.18.0](https://github.com/nvim-mini/mini.nvim/blob/v0.18.0/doc/mini-pick.txt): controles del picker.
- [nvim-tree v1.18.0](https://github.com/nvim-tree/nvim-tree.lua/blob/nvim-tree-v1.18.0/doc/nvim-tree-lua.txt): árbol lateral.
