# 04 - Learning Journal

## 2026-10-09 - Base and Documentation

### Decisions and Changes

- Adoptar MiniMax, conservar referencias antes de recortarlas y explicar cada cambio.
- Objetivo macOS/Arch, misma versión estable para uso diario; primer bloque HTML/CSS/JavaScript.
- Clonar con historial y remoto `upstream`; base `14bd13f20268cc6c8464afedfbe4ab2430f9c353`
  del 2026-10-03. Sin remoto personal ni publicación de commits.
- README propio y copia original, roadmap, guías y validación estática.
- Conservar `.nvimlog` preexistente e ignorarlo en Git.
- No modificar `setup.lua` ni las referencias `configs/` en esta etapa.

### Findings

- La raíz es un generador; no se activa al abrir Neovim aquí.
- El generador copia, respalda conflictos y puede crear repositorio/commit en el destino.
- 0.11/0.12 tienen gestores distintos; 0.11 fija revisiones Tree-sitter por compatibilidad.
- El ejemplo LuaLS no instala/activa servidor; la llamada de activación está comentada.
- `plugin/` se carga automáticamente en orden alfabético.

### Validation and Limits

- Mac observado: Neovim 0.11.4.
- Validación estática pasada: 28 archivos Lua, 10 JSON y estructura de los cuatro perfiles.
- Documentación verificada: 8 guías y 27 enlaces locales; README upstream idéntico al original.
- Generador probado con 0.11.4 en carpetas XDG temporales: selección del perfil
  0.11 y copia exacta de sus 9 archivos. No se ejecutó el init generado.
- Regeneración comprobada: respaldo de init/atajos en conflicto, conservación de
  override Markdown y archivo ajeno, y bloqueo cuando ya existe `MiniMax-backup`.
- El Git que crea el generador se probó solo en esa carpeta temporal, luego eliminada.
- Referencias, generador y licencia upstream sin diferencias; `git diff --check` pasó.
- **Pendiente:** arranque con plugins, integración web y prueba real en Arch.
- Sin instalación/actualización Homebrew o pacman.
- Sin modificar `/Users/jd/.config/nvim` ni su destino de dotfiles.

### Next Step

Recorrer `init.lua`, elegir versión estable común y preparar perfil aislado.
Recortar módulos y atajos juntos antes de añadir herramientas web.

## 2026-10-09 - Naming and Language Convention

- Crear `AGENTS.md` como fuente de las instrucciones compartidas del proyecto.
- Usar nombres de archivos y carpetas en inglés ASCII, títulos en inglés y
  contenido en español. Las tildes siguen permitidas en la prosa.
- Renombrar las cuatro guías a `01-installation.md`, `02-file-map.md`,
  `03-workflow.md` y `04-journal.md`; cambiar `docs/lenguajes/` a `docs/languages/`.
- Traducir los encabezados propios al inglés y actualizar enlaces y pruebas.
- Conservar las referencias upstream sin traducciones ni cambios de comportamiento.
- No crear `MEMORY.md`, `CONTEXT.md` ni `SKILL.md`: esta regla vive en `AGENTS.md`;
  el recorrido y el estado ya tienen su lugar en la bitácora y el roadmap.
- Verificar 9 documentos, 53 encabezados ASCII y 30 enlaces locales; validación
  estática de 28 Lua y 10 JSON correcta. `git diff --check` pasó y las referencias
  upstream permanecen intactas. No se instaló ni activó el perfil.

## 2026-10-09 - Isolated Learning Profile Installed

- Usuario aprobó coexistencia: conservar LazyVim y lanzar el perfil nuevo solo
  mediante `NVIM_APPNAME=nvim-learning`, sin exportarlo globalmente.
- Crear `learning/` con cuatro archivos Lua propios, comentarios explicativos y
  estructura de MiniMax. Conservar `configs/` y `setup.lua` originales intactos.
- Activar solo `mini.files`, `mini.pick` y `mini.statusline`, con `mini.deps` como
  gestor y mini.nvim v0.18.0 fijado al commit `1345d191bb3da9c7b0e977f4387c5761f9bff68d`.
- Crear instalador protegido: destino exacto, metadatos/hashes, rechazo de perfiles
  ajenos/enlaces/ediciones locales y respaldo de versiones gestionadas reemplazadas.
  No genera Git ni descarga plugins; estos se descargan al primer arranque.
- Instalar copia en `/Users/jd/.config/nvim-learning`; dependencia en los datos de
  ese perfil. Neovim permanece en 0.11.4, sin instalaciones Homebrew/pacman.
- Corregir un `E216` silencioso de integración con netrw: el explorador se abre
  por atajo, sin reemplazar el nativo. Borrados configurados hacia su papelera.
- Ampliar `.gitignore` para metadatos, logs, swaps, undo, `.env` privado y datos/
  respaldos generados. Verificadas 16 rutas excluidas y 8 conservadas, incluyendo
  fuentes, `.env.example` y lockfiles.
- Añadir guías 05/06 de lanzamiento, regreso a LazyVim, archivos propios y
  mantenimiento. Actualizar README, índice, roadmap y método a estado instalado.
- Pruebas pasadas: 36 Lua y 10 JSON estáticos; regresiones del instalador en XDG
  temporales; arranque real headless, módulos/atajos, explorador y apertura/guardado
  HTML/CSS/JavaScript en fixtures. Documentación y enlaces locales verificados.
- Enlace LazyVim y SHA256 de su `init.lua` idénticos al baseline; copia educativa
  coincide con fuente y hashes. README original/upstream permanece intacto.
- **Pendiente:** prueba visual interactiva y ejecución real en Arch; integración
  web avanzada y elegir versión común del editor. Falta URL de GitHub para `origin`;
  no se creó repo remoto ni se hicieron commits/pushes propios.

## 2026-10-09 - Blank Terminal Launch Fix

- Usuario reportó pantalla totalmente en blanco en Kitty y Ghostty. La prueba
  headless previa no validaba la conexión de la interfaz con la terminal.
- Reproducir el lanzamiento antiguo con RTK 0.43.0 en una pseudoterminal: dibuja
  filas vacías y, al recibir entrada, termina con error del proxy `os error 35`.
  El mismo binario/perfil conectado directamente dibuja Neovim y responde.
- Corregir comandos humanos en README y guías: `env NVIM_APPNAME=nvim-learning nvim`;
  para volver, `env -u NVIM_APPNAME nvim`. RTK solo para comandos automatizados,
  no para la TUI. No cambiar plugins ni opciones para ocultar el problema.
- Crear `scripts/launch.sh`, que conserva argumentos y ejecuta el editor directamente.
- Crear `tests/terminal.py`: copia config/dependencia a XDG temporales, crea una
  pseudoterminal, verifica pantalla sin archivo y con ruta con espacios, procesa
  un comando de teclado y comprueba cierre normal. No toca archivos del usuario.
- Prueba de terminal y sintaxis shell pasadas; añadir una regresión para evitar
  recomendar otra vez RTK delante de un lanzamiento interactivo.
- No reinstalar ni modificar la copia activa; enlace LazyVim intacto.
- El usuario confirmó «Sí, ahora se ve» al lanzar sin RTK. Arranque visual resuelto;
  no implica que todas las funciones estén probadas. Ejecución real en Arch pendiente.

## 2026-10-09 - Public Repository Setup

- El usuario creó [jdfesa/nvim](https://github.com/jdfesa/nvim), público y vacío,
  y autorizó crear commits y hacer push.
- Descripción elegida: «A minimal Neovim configuration built for learning, with
  clear documentation and incremental, modular improvements.» Sin limitar
  plataformas en la descripción; los sistemas de prueba siguen documentados aparte.
- Definir `origin` para el repo personal y conservar `upstream` como referencia,
  junto con el historial, README original y licencia MIT de MiniMax.
- Adoptar Conventional Commits en inglés y separar convenciones, configuración,
  documentación y pruebas. Guardar la regla en `AGENTS.md`.
- Actualizar las guías con la URL definitiva; conservar `.gitignore` y revisar
  el contenido público antes del push. No modificar el perfil instalado ni LazyVim.
- Pruebas previas pasadas: sintaxis Lua/JSON, instalador, arranque headless y
  terminal interactiva en copias temporales. Verificar 11 documentos y 42 enlaces
  locales, exclusiones Git y 70 archivos publicables sin patrones de secretos
  detectados. Esto no equivale a una auditoría exhaustiva ni prueba real en Arch.
