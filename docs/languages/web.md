# First Language Stack - HTML, CSS, and JavaScript

**Planificado: todavía no agregamos servidores, parsers ni formatters web.**

El perfil básico ya detectó y pudo abrir/guardar los tres filetypes en una prueba
headless con archivos temporales. Falta practicar con un ejercicio real; eso no
equivale a tener LSP, formato o ejecución de JavaScript configurados.

Objetivo: editar una página con estructura HTML, estilos CSS y comportamiento
JavaScript. Sin frameworks, TypeScript ni depurador dentro de Neovim al comienzo.

## Learning Order

1. Abrir/guardar `index.html`, `styles.css` y `main.js`; buffers y ventanas.
2. Confirmar filetypes y revisar indentación/comentarios.
3. Probar en el navegador y su consola.
4. Añadir LSP de uno en uno, explicando servidor, cliente y activación.
5. Añadir parsers Tree-sitter y comparar resaltado.
6. Elegir formatter y probar un atajo manual, no formato automático al guardar.
7. Evaluar linter cuando el ejercicio/proyecto lo necesite.

Opciones locales en `after/ftplugin/`; ajustes de servidores en `after/lsp/`;
instalación/activación compartida en `plugin/40_plugins.lua`. Autocompletado en
MINI, sin instalar un segundo motor por costumbre. Ampliar esta guía al decidir.

No elegimos gestores de servidores, paquetes npm ni formatter todavía.
Distinguiremos dependencias del editor y dependencias de cada proyecto.

## Future Acceptance Criteria

| Prueba | Esperado |
| --- | --- |
| `:set filetype?` | `html`, `css` o `javascript` según archivo |
| Abrir página en navegador | HTML/CSS visibles; JavaScript comprobable desde consola |
| `:checkhealth vim.lsp` tras configurar | Servidor disponible y adjunto al buffer esperado |
| Información/navegación LSP | Respuesta pertinente sin errores del cliente |
| Formato manual | Cambios previsibles; sin sorpresas al guardar |
| Repetir en macOS/Arch | Mismo comportamiento, diferencias de dependencias documentadas |

Son pruebas pendientes, no resultados obtenidos. Estado en el [roadmap](../../ROADMAP.md).
