# External References

Material de terceros para comparar y estudiar. **No es la configuración activa**
ni forma parte de los archivos gestionados por [nuestro instalador](../scripts/install.lua).
La fuente propia sigue en [learning/](../learning/); los atajos del perfil
educativo están en [KEYMAPS.md](../KEYMAPS.md).

## nvim-lite Pluginless

- **Author:** Radley E. Sidwell-lewis, según la cabecera original.
- **Project:** [radleylewis/nvim-lite](https://github.com/radleylewis/nvim-lite).
- **Source:** rama `pluginless`, commit
  [`2d1de3656a5f73717478692c6bc1be9e50b8f3dd`](https://github.com/radleylewis/nvim-lite/tree/2d1de3656a5f73717478692c6bc1be9e50b8f3dd).
- **Files:** [README original](nvim-lite-pluginless/README.md) e
  [init.lua original](nvim-lite-pluginless/init.lua).

Propuesta aportada por el usuario para analizar alternativas sin gestor de plugins.
El 2026-10-11 se comprobó mediante la API de GitHub que ambos archivos coinciden
exactamente con esa revisión. Conservamos contenido, nombres y atribución originales;
las explicaciones propias van aquí, no dentro de sus archivos.

El init original contiene espacios al final de algunas líneas. `.gitattributes`
exceptúa **solo ese archivo** de la comprobación de whitespace para conservar la
copia exacta; las fuentes propias mantienen los checks habituales.

### Installation Warning

El README original propone un comando que escribe en `~/.config/nvim/init.lua`.
**No ejecutarlo como procedimiento de este proyecto**: esa ruta corresponde al
perfil habitual y podría reemplazar su configuración. Esta referencia no se
instala, no se mezcla con `learning/` y no se carga al abrir Neovim en este repo.

Para nuestro perfil aislado, seguir [Installation](../docs/01-installation.md) y
[Launch and Separate Profiles](../docs/05-launch-and-profiles.md).

### Review Notes

No descargar plugins automáticamente no garantiza que todas las funciones sean
autosuficientes: el archivo usa `nvim_treesitter#foldexpr()` sin instalar ese plugin.
También conviene revisar el cierre de la última pestaña y los autocomandos al
recargar antes de reutilizar fragmentos. El análisis previo no equivale a adoptar
esta propuesta ni a validar todas sus funciones.

### License Status

En la revisión del 2026-10-11, la rama `pluginless` no incluía un archivo de
licencia y la API del repositorio devolvió `license: null` y HTTP 404 en `/license`.
No añadimos una licencia propia a estos archivos ni les atribuimos la MIT de
MiniMax conservada en la raíz. Mantenemos explícitos su origen y autoría; la
referencia no declara permisos adicionales de reutilización.
