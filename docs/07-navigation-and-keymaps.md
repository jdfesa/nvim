# 07 - Navigation and Practice Keymaps

El perfil educativo ya incluye barra lateral persistente, números relativos y
atajos para practicar archivos, ventanas y pestañas. No instala LazyVim: comparte
un subconjunto de sus teclas y conserva una configuración explicable.

La referencia completa de teclas, modos y alcance está en
[KEYMAPS.md](../KEYMAPS.md). Esta guía explica el flujo y propone ejercicios.

## Launch and First Keys

Desde la carpeta de tu ejercicio:

```sh
env NVIM_APPNAME=nvim-learning nvim
```

Pulsá `Esc` para entrar en modo Normal. **Espacio es Leader**: las teclas se
pulsan en secuencia, no todas juntas. Por ejemplo, `Espacio → f → f` busca archivos.
`Ctrl` y `Shift`, en cambio, sí se mantienen pulsados junto con la otra tecla.

Para empezar no memorices toda la guía: practicá primero `Espacio → e`,
`Espacio → f → f`, `Ctrl-h`/`Ctrl-l` y `Espacio → Tab → Tab`.

## Sidebar

`Espacio → e` abre o cierra el árbol de archivos a la izquierda. También sirve
`Espacio → f → e` o el comando `:NvimTreeToggle`. No es una ventana flotante:
permanece visible al abrir un archivo y podés volver a ella con `Ctrl-h`.
Al arrancar sin argumentos no aparece sola; al pasar una carpeta, como `nvim .`
con el perfil educativo, el árbol se abre para esa carpeta.

La barra usa `nvim-tree` v1.18.0, con revisión fija, sin otra dependencia de
iconos ni Nerd Font obligatoria. Reemplaza el explorador flotante `mini.files`;
el antiguo `Espacio → e → d` ya no está activo. No dejamos dos exploradores
distintos para memorizar ni una espera entre `e` y `ed`.

Con el cursor dentro de la barra, `j`/`k` recorren entradas y `Enter` abre el
archivo o expande la carpeta. `g?` muestra sus asignaciones locales.
Consultá [Sidebar](../KEYMAPS.md#sidebar) para crear archivos, abrir splits o
pestañas y cerrar el árbol. Son teclas locales: `q` dentro de la barra no sale
de todo Neovim.

Este perfil no asigna teclas de borrado o renombrado de archivos en la barra.
`Espacio → b → d` cierra un **buffer**, no elimina el archivo del disco. La barra
no cambia el directorio de trabajo al navegar; por ahora muestra ese directorio,
sin detección automática de raíz de proyectos. No activa Git ni diagnósticos.
Los cambios externos se refrescan con `R`, sin vigilantes del sistema de archivos.

## Relative Numbers

La línea actual muestra su número real; las demás muestran la distancia al cursor.
Si una línea aparece con `5`, `5j` permite bajar hasta ella; si está por encima,
`5k` permite subir. No hace falta pulsar `j` cinco veces.

`Espacio → u → L` activa o desactiva los números relativos de la ventana actual.
La `L` es mayúscula: **Shift-l**. El árbol lateral no necesita estos números.
Ayuda nativa: `:help 'relativenumber'` y `:help count`.

## Buffers, Windows, and Tabs

- **Buffer:** el contenido de un archivo abierto. Puede existir sin estar visible.
- **Ventana:** un espacio que muestra un buffer. Dos ventanas pueden mostrar el mismo archivo.
- **Pestaña:** una distribución de ventanas. No equivale a un archivo.

Para alternar entre HTML, CSS y JavaScript normalmente basta con buffers. Usá
splits para ver dos archivos al mismo tiempo y pestañas para separar distribuciones.
No añadimos todavía una barra de buffers como la que puede mostrar LazyVim.
La barra nativa de pestañas aparece cuando hay al menos dos pestañas.

### Files and Buffers

Abrí un archivo con `Espacio → f → f`, editá y guardá con `Ctrl-s`. Para un buffer
nuevo sin nombre, usá primero `:w index.html`. Para alternar archivos ya abiertos,
usá buffers en lugar de crear una pestaña por archivo.

Las tablas están en [Files and Search](../KEYMAPS.md#files-and-search) y
[Buffers](../KEYMAPS.md#buffers). El buscador tiene sus propios
[controles Picker](../KEYMAPS.md#picker): ahí `Ctrl-s` abre un split, no guarda.
Los aliases anteriores y diferencias están en
[LazyVim Compatibility](../KEYMAPS.md#lazyvim-compatibility).

### Windows

Los splits muestran inicialmente el mismo buffer. Después elegí otro archivo
con la barra o `Espacio → f → f` desde la ventana nueva.
Cerrar una ventana no equivale a cerrar el archivo que muestra.
Consultá [Windows](../KEYMAPS.md#windows) y
[Display Toggles](../KEYMAPS.md#display-toggles) para las teclas.

### Tabs

`Tab` es la tecla de tabulación física. Si solo queda una pestaña, el atajo de
cierre avisa y no produce el error de intentar cerrar la última. Para salir,
usá `:q` o `Espacio → q → q`.
Todas las secuencias están en [Tab Pages](../KEYMAPS.md#tab-pages).

## Five-Minute Practice

1. Abrí `index.html` desde la barra con `Enter`; comprobá que el árbol permanece visible.
2. Volvé a la barra con `Ctrl-h` y al archivo con `Ctrl-l`.
3. Practicá `3j` y `2k` usando los números del margen.
4. Creá un split con `Espacio → |` y abrí `styles.css` en la ventana nueva.
5. Creá una pestaña con `Espacio → Tab → Tab`; abrí `main.js` con `Espacio → f → f`.
6. Cambiá de pestaña, cerrá la nueva y comprobá que los buffers siguen disponibles.

No hace falta instalar LSP, snippets o formatters para estos ejercicios. Todavía
no hay ayuda semántica web: probá tu página en el navegador y su consola.

## Compatibility and Reversal

Compartimos intenciones y algunas teclas, no plugins ni una réplica completa de
LazyVim. Revisá las diferencias y aliases en
[LazyVim Compatibility](../KEYMAPS.md#lazyvim-compatibility) antes de migrar.

Para revertir un cambio, editá la fuente de `learning/`, repetí el instalador con
el perfil cerrado y reiniciá. El instalador guarda las versiones reemplazadas en
`learning-backup/`. No desactives solo `40_sidebar.lua` dejando atajos que lo llaman:
revertí también `20_keymaps.lua` y la desactivación de netrw en `init.lua`.
Para volver al editor habitual sin cambiar archivos: `env -u NVIM_APPNAME nvim`.

## References

- [Atajos oficiales de LazyVim](https://www.lazyvim.org/keymaps).
- [nvim-tree v1.18.0](https://github.com/nvim-tree/nvim-tree.lua/tree/nvim-tree-v1.18.0).
- Ayuda instalada: `:help nvim-tree`, `:help MiniBufremove`, `:help windows`, `:help tabpage`.
