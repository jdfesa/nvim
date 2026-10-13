# Documentation

Guías breves que acompañan los cambios, no un manual para leer entero antes de trabajar.

| Guía | Qué responde |
| --- | --- |
| [01 - Installation](01-installation.md) | Preparar macOS/Arch y separar el perfil |
| [02 - File Map](02-file-map.md) | Qué se ejecuta, cuándo y para qué |
| [03 - Workflow](03-workflow.md) | Dónde agregar una opción, módulo o lenguaje |
| [04 - Learning Journal](04-journal.md) | Qué hicimos y qué verificamos |
| [05 - Launch and Separate Profiles](05-launch-and-profiles.md) | Abrir el entorno educativo y regresar a LazyVim |
| [06 - Learning Profile](06-learning-profile.md) | Nuestros siete archivos, opciones, dependencias y límites GitHub |
| [07 - Navigation and Practice Keymaps](07-navigation-and-keymaps.md) | Barra lateral, relativos y atajos compatibles con LazyVim |
| [Languages - Web](languages/web.md) | HTML, CSS y JavaScript; proceso de completion/LSP como LazyVim |
| [Keymaps](../KEYMAPS.md) | Referencia rápida de teclas activas, modo, alcance y diferencias con LazyVim |
| [External References](../resources/README.md) | Propuestas de terceros para estudiar, no configuraciones activas |

El orden de trabajo está en el [roadmap](../ROADMAP.md).
Los nombres y títulos siguen las reglas de [AGENTS.md](../AGENTS.md); el contenido
permanece en español.

## New Feature Template

1. **Necesidad:** qué nos falta en un ejercicio.
2. **Concepto:** qué hace, en pocas líneas.
3. **Archivos:** dónde se configura y por qué ahí.
4. **Dependencias:** qué ejecutables necesita; diferencias macOS/Arch.
5. **Prueba:** acción concreta y resultado esperado.
6. **Reversión:** qué desactivar o restaurar.

Las opciones importantes también tendrán comentarios junto al código. La bitácora
registra el recorrido, no reemplaza la guía vigente.
Si un componente agrega, cambia o retira atajos, actualizar también
[KEYMAPS.md](../KEYMAPS.md) y ejecutar `tests/keymaps.lua`.
