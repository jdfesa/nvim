# 03 - Configuration Workflow

## One Change at a Time

Partimos de una necesidad de un ejercicio. Revisamos primero una función nativa;
si no alcanza, elegimos un módulo MINI o plugin específico. Lo comentamos,
probamos en el perfil aislado y registramos cómo revertirlo. Repetimos en el otro
sistema antes de declarar compatibilidad completa.

## Where Each Change Belongs

Dentro de nuestra **fuente canónica** `learning/`; `configs/` queda como referencia:

| Necesidad | Lugar |
| --- | --- |
| Comportamiento compartido | `plugin/10_options.lua` |
| Atajo global | `plugin/20_keymaps.lua` |
| Atajos documentados | `KEYMAPS.md`, en la raíz del repo |
| Módulo MINI | `plugin/30_mini.lua` |
| Plugin externo | `plugin/40_plugins.lua` |
| Opciones locales | `after/ftplugin/<filetype>.lua` |
| Ajustes LSP, desde 0.11 | `after/lsp/<server>.lua` |
| Snippets por lenguaje, si hacen falta | `after/snippets/<language>.json` |
| Explicación y pruebas | `docs/languages/<language>.md` |

Opciones, atajos y MINI ya existen. `40_plugins.lua` y `after/` son ubicaciones
para próximos cambios, no archivos vacíos que debamos crear hoy. Al añadir archivos,
actualizar la lista gestionada del instalador y sus pruebas.
No duplicamos perfiles por OS. Si un archivo crece, lo dividimos cuando haya una
responsabilidad clara, explicando cómo se carga.

Una opción para CSS no debe alterar todos los buffers: revisar `vim.bo`, `vim.wo`
o `setlocal` según su alcance. Los plugins se instalan una vez y se aplican a los
lenguajes correspondientes. Al retirar un módulo, revisar atajos y dependencias.
Al agregar, cambiar o quitar un atajo, actualizar [KEYMAPS.md](../KEYMAPS.md) y
ejecutar `tests/keymaps.lua`. La guía 07 conserva conceptos y ejercicios, no una
segunda copia de todas las tablas.

## Language Support Has Multiple Layers

- **Filetype:** identifica el tipo de archivo.
- **Edición:** indentación, comentarios y preferencias locales.
- **Runtime:** ejecuta el programa; al principio puede ser el navegador.
- **LSP:** servidor externo para información, navegación y diagnósticos.
- **Tree-sitter:** parser de estructura que ayuda al resaltado y otras acciones.
- **Formatter:** reordena texto según reglas de formato.
- **Linter:** comprueba reglas y posibles problemas; no equivale a formato.

No instalamos todo a la vez. Node/npm pueden ser dependencias de herramientas
web aunque nuestros ejercicios se ejecuten en el navegador.

## Portability and Maintenance

- Usar `stdpath` para carpetas y `PATH` para ejecutables, no rutas personales.
- Compartir Lua; documentar instalación y portapapeles por sistema/sesión.
- Elegir la misma versión estable en ambas máquinas.
- No actualizar editor, plugins y configuración simultáneamente sin verificar cada capa.
- Conservar revisiones de plugins y revisar diferencias/backups al actualizar.
- Mantener cambios en el perfil fuente del repo, no solo en su copia generada.
- Cerrar el perfil, repetir `scripts/install.lua` y reiniciar para aplicar cambios.
  Si detecta modificaciones locales en la copia, revisarlas y trasladarlas antes.

## What a Test Proves

1. **Sintaxis:** Lua compila y JSON se puede leer.
2. **Generador:** copia la referencia correcta y maneja conflictos.
3. **Arranque:** módulos/plugins cargan sin errores relevantes.
4. **Función:** acción concreta funciona en un ejercicio.
5. **Portabilidad:** también funciona en el otro sistema.

Pasar una categoría no demuestra las siguientes. Registrar el alcance real en
la [bitácora](04-journal.md). Las referencias upstream siguen sin modificaciones
como referencias. Nuestro perfil recortado sí está instalado; ver la
[guía de lanzamiento](05-launch-and-profiles.md).
