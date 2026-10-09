# 06 - Learning Profile

## Source and Installed Copy

`learning/` es nuestra fuente propia, derivada de la estructura de MiniMax 0.11.
`configs/` conserva las cuatro referencias originales para estudiar y comparar.
No instalamos MiniMax completo ni modificamos esas referencias.

| Archivo propio | Responsabilidad |
| --- | --- |
| `learning/init.lua` | Validar perfil/versión, preparar mini.nvim y gestor mini.deps |
| `learning/plugin/10_options.lua` | Opciones nativas y tema incluido en Neovim |
| `learning/plugin/20_keymaps.lua` | Seis atajos globales, sin llamadas a módulos desactivados |
| `learning/plugin/30_mini.lua` | Activar solamente explorador, búsqueda y barra de estado |
| `scripts/install.lua` | Copiar estos cuatro archivos al perfil aislado y proteger cambios locales |
| `scripts/launch.sh` | Lanzar la interfaz directamente, sin RTK, conservando argumentos |
| `tests/install.lua` | Probar el instalador en destinos temporales |
| `tests/smoke.lua` | Comprobar el arranque real y edición en archivos temporales |
| `tests/terminal.py` | Probar pantalla y teclado del lanzador en pseudoterminal, con datos temporales |

Neovim ejecuta `init.lua` primero y carga automáticamente los archivos de `plugin/`
en orden alfabético. No hace falta añadir tres `require` al init para cargarlos.
Los atajos llaman a los módulos al usarlos, después de finalizar el arranque.

Los títulos de los comentarios están en inglés y sus explicaciones en español.
No hay rutas de usuario ni comandos exclusivos de macOS dentro de la fuente Lua.

## First Options

Mostrar números, no envolver líneas, abrir splits debajo/a la derecha, indentar
con dos espacios y buscar con `ignorecase`/`smartcase`. `undofile` conserva el
historial de deshacer en el estado propio del perfil. El tema `habamax` viene con
Neovim; no agrega un plugin. Las opciones se explican junto a cada asignación.

No configuramos aún portapapeles automático ni reglas especiales por lenguaje.

## First Keymaps

En modo Normal, `<Leader>` significa **Espacio**, seguido de las otras teclas:

| Atajo | Acción |
| --- | --- |
| Espacio, `e`, `d` | Abrir explorador en el directorio de trabajo |
| Espacio, `f`, `f` | Buscar archivos |
| Espacio, `f`, `g` | Buscar texto con ripgrep; avisa si falta `rg` |
| Espacio, `f`, `b` | Buscar buffers abiertos |
| Espacio, `f`, `h` | Buscar ayuda |
| `Esc` | Quitar resaltado de la búsqueda |

El explorador se abre explícitamente; todavía no reemplazamos `netrw` al abrir
una carpeta. `?` muestra su ayuda. Navegación habitual: `h`/`l`, `L` para abrir un
archivo y cerrar el explorador, `q` para salir. Sus cambios de archivos se aplican
con sincronización y confirmación; los borrados van a su papelera propia.
Leer `:help MiniFiles` antes de usar operaciones sobre archivos.

## Dependency and Revision

Hay una dependencia descargada: `mini.nvim` **v0.18.0**, commit
`1345d191bb3da9c7b0e977f4387c5761f9bff68d`. Se activan `mini.files`, `mini.pick`
y `mini.statusline`, más `mini.deps` como gestor. Sin iconos especiales obligatorios.

El bootstrap clona la versión fijada en los datos del perfil, usando una carpeta
`.installing` hasta completar la descarga. Si falla, avisa y deja esa carpeta para
revisión; no borra datos automáticamente. En arranques posteriores comprueba el
commit instalado y no descarga de nuevo. No hay actualización automática.

`MiniDeps.add` registra el pin para sus comandos, pero **no corrige una revisión
existente**. Por eso el init la comprueba. Para actualizar en el futuro cambiaremos
el tag y el commit juntos, revisaremos diferencias y haremos una actualización
controlada con respaldo; no actualizar plugins a ciegas. `mini.deps` sigue
soportado para 0.11; evaluaremos `vim.pack` si elegimos 0.12+ como base común.

Todavía no hay LSP, parsers adicionales, autocompletado añadido, snippets,
formatter ni linter. Detectar HTML/CSS/JavaScript no equivale a instalar esos servicios.

## GitHub Boundaries

Compartir fuentes, documentación, scripts, pruebas y licencia. No subir la carpeta
de plugins ni copiar los datos de Neovim al repo. `.gitignore` excluye metadatos
macOS, logs, swaps, undo local, `.env` privado y respaldos/datos generados. Conserva
`.env.example`, lockfiles y snapshots que decidamos versionar.

El repositorio personal es [jdfesa/nvim](https://github.com/jdfesa/nvim), remoto
`origin` en esta copia de trabajo. `upstream` sigue apuntando a MiniMax; conservamos
su historial y licencia sin publicar nuestros cambios allí. Los commits propios
siguen Conventional Commits en inglés. Antes de publicar, revisar también archivos
ya rastreados y secretos: `.gitignore` no los elimina.

## References

- [Referencia original MiniMax 0.11](../configs/nvim-0.11/init.lua).
- [mini.nvim v0.18.0](https://github.com/nvim-mini/mini.nvim/tree/v0.18.0).
- Ayuda instalada: `:help MiniDeps`, `:help MiniFiles`, `:help MiniPick`, `:help MiniStatusline`.
