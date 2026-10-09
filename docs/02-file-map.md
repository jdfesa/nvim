# 02 - File Map

**Fuente propia:** `learning/`, el perfil recortado que instalamos.
**Referencias:** `configs/`, plantillas originales de MiniMax para comparar.
**Perfil activo:** copia generada en la ruta de `stdpath('config')`.
Neovim no selecciona automáticamente una configuración por el directorio de trabajo.

## Repository Root

| Archivo/carpeta | Responsabilidad |
| --- | --- |
| `README.md` | Entrada propia y estado actual |
| `README.upstream.md` | Guía original de MiniMax |
| `ROADMAP.md` | Etapas y criterios de avance |
| `AGENTS.md` | Instrucciones para trabajar en el repo: nombres, títulos e idioma; no configura Neovim |
| `docs/` | Guías, lenguajes y bitácora |
| `learning/` | Fuente canónica propia, cuatro archivos Lua explicados en la guía 06 |
| `scripts/install.lua` | Instalador del perfil recortado; no crea Git ni instala plugins |
| `scripts/launch.sh` | Lanzador interactivo directo, sin envolver Neovim en RTK |
| `setup.lua` | Generador; no es el init del editor |
| `configs/README.md` | Explicación upstream de referencias/diferencias |
| `configs/nvim-0.10/` | Referencia 0.10; no objetivo inicial |
| `configs/nvim-0.11/` | Referencia que selecciona el Neovim 0.11.4 del Mac |
| `configs/nvim-0.12/` | Referencia con gestor nativo `vim.pack` |
| `configs/nvim-0.13/` | Referencia marcada como desarrollo |
| `CHANGELOG.md` | Cambios upstream; los nuestros van en la bitácora |
| `LICENSE` | Licencia MIT y atribución original |
| `logo.png` | Presentación; no configura Neovim |
| `.stylua.toml` | Reglas de StyLua; no activa un formatter por sí sola |
| `.github/ISSUE_TEMPLATE/` | Formularios del proyecto original |
| `.github/PULL_REQUEST_TEMPLATE.md` | Plantilla de contribuciones upstream |
| `.gitignore` | Excluye metadatos, temporales, variables privadas y datos/respaldos locales |
| `tests/validate.lua` | Sintaxis Lua/JSON y estructura, sin plugins |
| `tests/install.lua` | Regresiones del instalador, en XDG temporales |
| `tests/smoke.lua` | Arranque real y edición de archivos temporales |
| `tests/terminal.py` | Regresión de pantalla/teclado en pseudoterminal; no prueba una app terminal concreta |
| `.git/` | Historial y remotos, no configuración del editor |

## Inside an Upstream Profile

Empezar junto al código de [la referencia 0.11](../configs/nvim-0.11/init.lua).
Esta sección explica upstream. Nuestro perfil activo solo conserva la estructura
`init.lua` + opciones/atajos/MINI; sus archivos están en [Learning Profile](06-learning-profile.md).

| Archivo | Qué hace y cuándo |
| --- | --- |
| `init.lua` | Primero al arrancar: prepara gestor, tabla global `Config` y helpers |
| `plugin/10_options.lua` | Opciones nativas: números, búsqueda, indentación, ventanas, undo y diagnósticos |
| `plugin/20_keymaps.lua` | Atajos por modo; Leader es espacio, definido antes en opciones |
| `plugin/30_mini.lua` | Activa módulos con `require('mini.nombre').setup(...)`; aquí recortaremos MINI |
| `plugin/40_plugins.lua` | Plugins externos: Tree-sitter, configuraciones LSP, formato y snippets |
| `snippets/global.json` | Ejemplos compartidos para expandir fecha/hora |
| `after/ftplugin/markdown.lua` | Ajustes locales al detectar Markdown, después de los habituales |
| `after/lsp/lua_ls.lua` | Tabla de ajustes LuaLS en 0.11+; no instala ni activa el servidor |
| `after/snippets/lua.json` | Snippets Lua y overrides con prioridad en `mini.snippets` |
| `nvim-pack-lock.json` | Desde 0.12: revisiones de plugins, conservar en Git y no editar a mano |

### Code Reading Concepts

- `vim.o.xxx` asigna una opción. `:help 'xxx'` explica valores y alcance.
- `vim.keymap.set` crea atajos. Algunos llaman módulos al presionarlos, no al
  definirlos: pueden existir antes de la configuración de esos módulos.
- Un autocomando reacciona a eventos como `FileType` o `LspAttach`; no es un atajo.
- `Config` comparte helpers entre archivos; no es una opción nativa de Neovim.
- `now`/`later` organizan la carga: **diferir no significa desactivar**.
- 0.11 prepara `mini.deps`; 0.12+ utiliza `vim.pack` y helpers de `mini.misc`.
  No son los mismos comandos de gestión.
- `after/ftplugin/` modifica comportamiento por **filetype**; `after/lsp/` ajusta
  un **servidor**, que puede atender más de un filetype.
- Los snippets insertan texto; no aportan diagnósticos ni comprensión del lenguaje.
- En 0.11 la alternativa al lockfile es un snapshot de `mini.deps`.

### What Cloning Does Not Set Up

`40_plugins.lua` trae parsers de ejemplo Lua/vimdoc/Markdown, no los web.
La activación LSP está comentada y la lista de formatters no está configurada.
Mason es una sugerencia comentada, no una instalación activa. La referencia
original tiene muchas más funciones que nuestra meta mínima; todavía no la recortamos.

## Load Order

1. `scripts/install.lua` se ejecuta **solo al invocarlo** para copiar nuestro perfil.
   `setup.lua` es la alternativa original para referencias completas, no la que usamos.
2. Al arrancar ese perfil, Neovim ejecuta su `init.lua`.
3. Carga automáticamente `plugin/*.lua` en orden alfabético: opciones → atajos →
   MINI → otros plugins. No necesitan cuatro `require` dentro del init.
4. Los bloques diferidos se ejecutan después.
5. Al abrir archivos y activar servidores se aplican los ajustes pertinentes de
   filetype/LSP/snippets; no todo `after/` se ejecuta de golpe al arrancar.

`plugin/` no es `lua/`: los archivos de `lua/` suelen ser módulos que cargamos
mediante `require`, mientras `plugin/` participa de la carga automática.

Ayuda: `:help startup`, `:help load-plugins`, `:help runtimepath`, `:help lua-guide`
y [estructura upstream](../configs/README.md).
