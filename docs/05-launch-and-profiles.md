# 05 - Launch and Separate Profiles

## Current Setup

El perfil de aprendizaje ya está instalado en el Mac observado. LazyVim sigue
siendo el entorno habitual; no cambiamos su enlace ni exportamos variables en la shell.

| Perfil | Configuración en este Mac | Cómo se elige |
| --- | --- | --- |
| LazyVim | `/Users/jd/.config/nvim` → `/Users/jd/mydotfiles/shared/nvim` | Sin `NVIM_APPNAME` |
| Aprendizaje | `/Users/jd/.config/nvim-learning` | `NVIM_APPNAME=nvim-learning` |

## Open the Learning Profile

Desde cualquier carpeta, no solo desde este repositorio:

```sh
env NVIM_APPNAME=nvim-learning nvim
```

También podés abrir un archivo agregando su ruta al final. La variable se aplica
solo a ese proceso. **No usar `--clean` al abrirlo:** omitiría nuestra configuración.
No agregar un `export NVIM_APPNAME=...` a tu configuración de shell.

**No anteponer `rtk proxy` a este lanzamiento.** Se reprodujo una pantalla vacía
con RTK 0.43.0; el mismo perfil, conectado directamente a una terminal, dibuja la
interfaz y responde al teclado. RTK no es dependencia de Neovim y lo usamos solo
para comandos automatizados sin interfaz interactiva.

Como alternativa, desde la raíz del repo:

```sh
sh scripts/launch.sh
```

El script conserva todos los argumentos y ejecuta Neovim directamente. No crea
alias, no modifica tu shell y no cambia el directorio de trabajo.

## Return to LazyVim

Guardar el ejercicio y cerrar con `:qa`. Después:

```sh
env -u NVIM_APPNAME nvim
```

Este comando elimina la variable solo para ese proceso. No restaura archivos ni
reinstala LazyVim porque nunca lo reemplazamos. Podés tener ambos perfiles abiertos
a la vez, pero evitá editar el mismo archivo en dos instancias simultáneamente.

## Verify the Active Profile

Dentro de Neovim:

```vim
:echo $NVIM_APPNAME
:echo stdpath('config')
:echo stdpath('data')
:lua print(vim.g.learning_profile)
```

En el perfil educativo, el nombre es `nvim-learning` y la marca es `true`.
Las carpetas estándar de configuración, datos, estado y caché llevan ese nombre;
plugins e historial no comparten sus rutas con el perfil habitual.

Ambos usan el **mismo binario de Neovim**. No se aíslan su versión, las herramientas
externas de `PATH` ni los archivos de tus ejercicios. Cambiar de perfil no deshace
cambios que hayas guardado en un proyecto.

## Blank Screen Troubleshooting

Si arrancaste con el comando antiguo que contenía `rtk proxy`, cerrar esa instancia
y repetir el comando directo en una pestaña nueva. No reinstalar ni borrar datos.
Si el problema persiste con el lanzamiento directo, registrar el comando exacto,
terminal y error visible; no asumir que el arranque headless demuestra que la TUI funciona.

## Install or Refresh on Another Machine

Instalar Neovim 0.11.3+ y Git; `ripgrep` permite nuestro atajo de búsqueda de texto.
Node.js/npm y utilidades de descarga/extracción permiten instalar los servidores web.
Clonar [jdfesa/nvim](https://github.com/jdfesa/nvim) y, desde su raíz, revisar y ejecutar:

```sh
rtk proxy env NVIM_APPNAME=nvim-learning nvim --clean -l scripts/install.lua
```

El instalador copia `learning/`; no crea repositorios ni descarga plugins. Al
primer arranque, el perfil descarga los siete plugins con revisiones fijadas y
Mason instala los tres servidores web. Proceso, pruebas y reversión en
[Web Completion](languages/web.md).
Detalles de instalación en [Installation](01-installation.md).

La copia instalada **no es un enlace al repo**. Para mantener cambios en GitHub,
editar los archivos de `learning/` y repetir el instalador, con el perfil cerrado.
Si detecta una edición local distinta en la copia, se detiene antes de sobrescribir.
Si cambia una fuente, respalda su versión instalada bajo
`learning-backup/<timestamp>-<pid>/` dentro de la configuración educativa.

Arch usa el mismo mecanismo y la misma fuente Lua; su prueba real sigue pendiente.

## Reference

[NVIM_APPNAME y rutas estándar, documentación oficial de Neovim 0.11.4](https://raw.githubusercontent.com/neovim/neovim/v0.11.4/runtime/doc/starting.txt).
