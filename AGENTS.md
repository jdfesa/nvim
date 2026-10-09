# Project Instructions

@/Users/jd/.codex/RTK.md

## Naming and Language

- Todos los archivos y directorios propios que generemos deben tener nombres en
  inglés y usar solo caracteres ASCII: letras, números, guiones, guiones bajos y
  puntos. No usar espacios, tildes, `ñ` ni otros caracteres especiales en las rutas.
- Preferir `kebab-case` para documentos y carpetas, por ejemplo
  `01-installation.md` y `docs/languages/`.
- Respetar nombres convencionales o exigidos por una herramienta, como
  `README.md`, `ROADMAP.md`, `AGENTS.md`, `init.lua` y `lua_ls.lua`.
- Escribir en inglés los títulos y encabezados de los documentos que generemos.
- Escribir en español el contenido, las explicaciones y los comentarios del
  código. Las tildes y la `ñ` sí están permitidas en el contenido; ASCII no es
  una restricción para la prosa.
- Al renombrar un archivo, actualizar sus enlaces, referencias y pruebas.

## Upstream References

Conservar los nombres y el contenido original de referencias de terceros, como
`README.upstream.md` y los perfiles de MiniMax, salvo cambios explícitos y
documentados. No traducir ni renombrar archivos upstream solo por esta convención.

## Learning Workflow

Avanzar con cambios pequeños y documentados, explicando qué hace cada archivo.
Mantener macOS y Arch Linux como sistemas objetivo. El primer bloque de ejercicios
es HTML, CSS y JavaScript; añadir herramientas según una necesidad concreta.

La fuente propia está en `learning/`; `scripts/install.lua` copia sus archivos al
perfil `nvim-learning`. Mantener intacto el perfil habitual y no exportar
`NVIM_APPNAME` globalmente. Al agregar otro archivo al perfil, actualizar la lista
gestionada del instalador y sus pruebas. `configs/` y `setup.lua` siguen como
referencias originales, no como el instalador del perfil educativo.

## Interactive Launch

La regla RTK se aplica a comandos de herramientas del agente. Los comandos de
lanzamiento que documentamos para el usuario y `scripts/launch.sh` deben ejecutar
Neovim directamente, sin RTK: `env NVIM_APPNAME=nvim-learning nvim`. RTK 0.43.0
reprodujo una TUI en blanco. Probar interfaz con una pseudoterminal además de los
checks headless; no presentar estos últimos como validación visual.

## Version Control

- Usar Conventional Commits, con mensajes en inglés: `type(scope): description`.
  Por ejemplo, `feat(config): add isolated learning profile` o
  `docs: explain configuration load order`.
- Separar cambios por responsabilidad y revisar las pruebas antes de publicar.
- El remoto personal es `origin`, en `https://github.com/jdfesa/nvim.git`.
  `upstream` es la referencia original de MiniMax; no publicar cambios propios allí.
- Conservar el historial y la licencia upstream. No hacer force push.
- Revisar también archivos rastreados: `.gitignore` no elimina secretos del historial.
