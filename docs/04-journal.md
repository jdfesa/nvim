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

## 2026-10-11 - Sidebar and Practice Navigation

- Usuario pidió barra lateral real, números relativos y atajos de navegación
  compatibles con LazyVim para practicar antes de una posible migración.
- Añadir `learning/plugin/40_sidebar.lua`: nvim-tree v1.18.0, commit
  `531b807b8f0d6f75016a0ee1e0cd5ce2086e9d95`, gestionado por mini.deps y verificado
  al arrancar. Sin nvim-web-devicons ni Nerd Font obligatoria.
- Reemplazar mini.files flotante por la barra persistente; MINI conserva búsqueda
  y barra de estado y añade mini.bufremove para cerrar buffers sin perder ventanas.
- Activar relativos, cursorline y contexto de desplazamiento; compartir atajos
  para sidebar, guardar, buffers, splits y pestañas. Proteger el cierre de la
  última pestaña. No añadir LSP, parsers, snippets ni formato automático.
- `Espacio, e` reemplaza `Espacio, e, d`; `Espacio, s, g` es el atajo recomendado
  de búsqueda de texto. Conservar fg/fh como aliases, documentando la diferencia
  con LazyVim. No asignar borrado/renombrado de archivos dentro de la barra.
- Corregir `E216 FileExplorer` silencioso de nvim-tree: netrw deshabilitado y
  `hijack_netrw=false`, sin limpiar un grupo inexistente. Refresco externo con R
  en vez de watchers, manteniendo el comportamiento sencillo y portable.
- Ampliar instalador y pruebas a cinco archivos gestionados; comprobar migración
  desde cuatro archivos y rechazo de un quinto archivo ajeno.
- Añadir guía 07 con buffers/ventanas/pestañas, ejercicios y tabla de atajos;
  actualizar guías vigentes, README y roadmap. Conservar el historial anterior.
- Pruebas estáticas e instalador pasadas. Smoke verifica edición web y atajos de
  sidebar/relativos/splits/tabs/cierre de buffers. PTY comprueba dibujo de la barra
  y teclas reales, además de pantalla inicial, rutas con espacios y cierre.
  Abrir una carpeta también muestra su árbol sin error.
- Instalar en `/Users/jd/.config/nvim-learning`, con respaldo de versiones previas
  en `learning-backup/20261011-052156-47683/`. Primer arranque instalado descargó
  nvim-tree, aplicó su pin y pasó el smoke. MINI sigue en su pin original.
- El init.lua propuesto en la raíz permanece intacto y no instalado; referencias
  upstream, LazyVim y binario Neovim 0.11.4 sin cambios. No hacer commits ni push.
- **Pendiente:** confirmar experiencia en la terminal habitual con el usuario,
  práctica real del ejercicio web y ejecución en Arch.

## 2026-10-11 - Canonical Keymap Reference

- El usuario autorizó investigar y crear una referencia de atajos usando
  terminología comunitaria y exposición gradual al inglés.
- Consultar documentación oficial de Neovim y LazyVim: usan mappings/keymaps;
  `KEYMAPS.md` es nuestra convención documental, no un nombre obligatorio del editor.
- Crear [KEYMAPS.md](../KEYMAPS.md) con notación, modos, alcance, mapas globales,
  barra lateral, controles básicos del picker, comandos nativos y diferencias
  con LazyVim. Aclarar que Ctrl-s en mini.pick abre un split, no guarda.
- Mantener conceptos y ejercicios en la guía 07 y sustituir sus tablas completas
  por enlaces a la referencia. Enlazar el archivo desde README, índice y mapa.
- Registrar en AGENTS.md: nombres/identificadores/encabezados ingleses, prosa
  española por ahora, terminología comunitaria y actualización conjunta de atajos.
- Añadir `tests/keymaps.lua`: captura las definiciones con dependencias simuladas
  y compara 46 combinaciones de tecla/modo/alcance. No descarga plugins ni ejecuta
  acciones; no valida controles internos de mini.pick ni interfaz.
- Pruebas pasadas: 38 Lua y 10 JSON estáticos, instalador protegido y consistencia
  de mapas. Cinco fixtures temporales rechazaron omisiones, modo/alcance incorrectos,
  mapas extras y duplicados. Revisar 13 documentos, enlaces locales/anchors
  y encabezados ASCII en inglés; `git diff --check` sin errores.
- Solo documentación y prueba de consistencia en este cambio: no reinstalar el
  perfil, cambiar plugins, editar upstream ni hacer commits/push. La validación
  funcional previa sigue registrada arriba; no confundir estas pruebas con UI.
- **Pendiente:** usar la referencia durante la práctica web y mantenerla junto
  con cada componente futuro. Prueba real en Arch y experiencia habitual pendientes.

## 2026-10-11 - Publication and External Reference

- El usuario autorizó Conventional Commits en inglés y push a `origin/main`.
  Publicar `7f27fbb` para sidebar/navegación con pruebas funcionales y `56a2785`
  para referencia de keymaps, guías y consistencia documental.
- Antes de publicar, repetir pruebas estáticas, instalador, keymaps, smoke aislado
  y pseudoterminal; todas pasaron. Revisar enlaces y patrones de credenciales en
  archivos rastreados/nuevos, sin hallazgos; no es una auditoría exhaustiva.
- El usuario confirmó incluir nvim-lite como referencia externa, conservando su
  atribución. Guardar README e init originales bajo `resources/nvim-lite-pluginless/`
  y explicación propia en [External References](../resources/README.md).
- GitHub API confirmó copias exactas de la rama `pluginless`, commit
  `2d1de3656a5f73717478692c6bc1be9e50b8f3dd`, con atribución a Radley E. Sidwell-lewis.
  El origen no declara licencia explícita; no añadir una propia a esos archivos.
- Advertir que el comando del README externo escribe en el perfil habitual.
  No ejecutar, instalar ni mezclar esta propuesta con `learning/`.
- Conservar el whitespace original mediante una excepción `.gitattributes`
  limitada a ese init. Metadatos `.DS_Store` siguen excluidos de Git.
- Validación estática ampliada a la sintaxis de la referencia sin ejecutarla:
  39 Lua y 10 JSON, más instalador y las 46 combinaciones de keymaps, pasaron.
- El perfil educativo, LazyVim, binario y referencias MiniMax no cambian en esta
  publicación. La ejecución real en Arch continúa pendiente.

## 2026-10-12 - LazyVim Completion and Web Language Servers

### Need and Decision

- El usuario pidió sugerencias inteligentes mientras escribe, como en su LazyVim,
  y documentación del proceso; no solo un snippet HTML propio. Autorizó implementar.
- Revisar LazyVim en modo lectura: usa Blink v1.10.2, friendly-snippets y preset
  `enter`, con fuentes lsp/path/snippets/buffer. Su colección contiene `html5`.
  La propuesta mini.completion/mini.snippets no llegó a activarse.
- El entorno habitual no tenía servidores web instalados. Replicar su motor y
  controles e incorporar HTML/CSS/JavaScript como necesidad concreta; no importar
  toda LazyVim ni instalar frameworks, depurador, parsers o formatter dedicado.

### Changes and Installation

- Añadir `learning/plugin/50_completion.lua`: pins Blink/friendly-snippets,
  menú automático, documentación a 200 ms, Enter para aceptar, campos con Tab.
  Usar vim.snippet; texto en vez de iconos para no exigir Nerd Font o Tree-sitter.
- Añadir `learning/plugin/60_web_lsp.lua`: pins nvim-lspconfig/Mason/mason-lspconfig,
  capacidades de Blink y activación limitada a html/cssls/vtsls. Vtsls solo para
  JavaScript; su dependencia interna de TypeScript no amplía el bloque de estudio.
- Mantener mini.deps, MINI, sidebar y tema actuales. Los cinco plugins nuevos
  usan revisiones verificadas del checkout habitual; registrar en la guía la
  diferencia entre el checkout real de mason-lspconfig y su lockfile.
- Instalar html-lsp/css-lsp **4.10.0** y vtsls **0.3.0** en el Mason exclusivo de
  nvim-learning; sin npm global ni cambios en el Mason de LazyVim.
- Reutilizar Node **22.20.0** / npm **10.9.3** ya disponibles; conservar Neovim
  **0.11.4**. nvim-lspconfig fijado exige 0.11.3+: actualizar guardias y guías.
- Ampliar instalador a siete archivos y probar migración desde cinco, conflictos
  de los nuevos archivos, respaldo e idempotencia. Instalar copia gestionada con
  respaldo en `learning-backup/20261012-204549-79279/`.
- Añadir flag `learning_web_tools` para reversión sin borrar datos. Ampliar guía
  web, KEYMAPS, README, workflow, requisitos, mapa de archivos y roadmap.
  Los mapas locales de completion se separan de los globales y del command-line.

### Findings

- Esta revisión de mason-lspconfig no ejecuta ensure_installed en headless:
  para el bootstrap automatizado usar `:MasonInstall` explícito. En TUI instala
  lo solicitado normalmente. El guard no es un fallo de instalación del servidor.
- Receipts Mason v2 usan `schema_version = "2.0"` y `source.id`; comprobar ese
  formato para verificar versiones, no el antiguo campo `primary_source`.
- Ensure_installed con versión fija solo nuevas instalaciones; no corrige paquetes
  ya presentes ni bloquea todas las dependencias transitivas. No prometer un lock total.
- Shift-Tab vuelve al comienzo del campo seleccionado; una aserción que comparaba
  la columna final después de escribir era incorrecta. Verificar el campo/fila.
- El sandbox rechazó escritura de lsp.log del perfil instalado en un check sin
  permisos; repetir autorizado para logs aislados. Las pruebas PTY usan XDG temporales.

### Validation and Limits

- Pasar checks estáticos de **42 Lua y 10 JSON**, instalador y **70 combinaciones**
  de tecla/modo/alcance. Integración también compara los mapas reales de Blink.
- `tests/web-completion.lua`: versiones/paths aislados, capacidades de snippets,
  clientes reales y candidatos `div`, `color`, `toUpperCase`; sin LSP en TypeScript.
- Smoke de navegación previo sigue pasando con el nuevo stack.
- `tests/terminal.py`: menú automático de HTML/CSS/JS sin invocar cmp.show;
  Enter expande html5 y acepta el método JS, edición del idioma, Tab/Shift-Tab y
  cancelación con Ctrl-e. Verificar sidebar y navegación anteriores y reversión por flag.
- El timer de la prueba observa sin salir de Insert; no confundir respuesta LSP
  con menú visible ni headless con prueba visual. PTY POSIX no es inspección en
  Kitty/Ghostty ni prueba real de Arch, que siguen pendientes.
- Verificar enlaces locales y coincidencia de los siete archivos instalados con
  fuente/hashes. El enlace de LazyVim y sus **27 archivos** de configuración
  conservan SHA256; referencias upstream, CHANGELOG y licencia intactos.
- Durante la implementación, conservar cambios locales previos de documentación/guía
  visual; todavía sin commits ni push en esa etapa.

### Publication Scope

- El usuario autorizó commits en inglés con Conventional Commits y push a `origin`.
  Confirmó incluir **solo autocompletado web y su documentación**; la guía visual
  y las explicaciones anteriores de edición/buffers quedan pendientes.
- Separar configuración/pruebas/atajos de la explicación del proceso en dos commits:
  `feat(completion): add LazyVim-style web completion` y
  `docs(web): document completion setup and learning workflow`.
- Repetir pruebas estáticas, instalador, keymaps, integración LSP y pseudoterminal
  antes de publicar. Comprobar el estado remoto; no publicar en `upstream` ni forzar push.

### Next Step

Reiniciar el perfil en la terminal habitual, practicar html5 y un ejercicio pequeño
con CSS/JavaScript y navegador; confirmar experiencia visual y repetir en Arch.
Después de publicar, continuar por necesidades concretas y cambios documentados.
