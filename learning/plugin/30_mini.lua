-- MINI Modules
-- Descargar mini.nvim no activa todos sus módulos: cada setup activa solo uno.
-- El explorador flotante mini.files deja paso a la barra lateral de 40_sidebar.lua.
require('mini.pick').setup()
require('mini.statusline').setup({ use_icons = false })
-- Cerrar un archivo sin destruir la distribución de ventanas ni la barra lateral.
require('mini.bufremove').setup()

-- Completion y LSP viven en 50_completion.lua y 60_web_lsp.lua.
-- No activar mini.completion/mini.snippets: usamos el motor y colección de LazyVim.
-- Seguimos sin parsers adicionales, formatter ni formato automático al guardar.
