-- MINI Modules
-- Descargar mini.nvim no activa todos sus módulos: cada setup activa solo uno.
-- El explorador flotante mini.files deja paso a la barra lateral de 40_sidebar.lua.
require('mini.pick').setup()
require('mini.statusline').setup({ use_icons = false })
-- Cerrar un archivo sin destruir la distribución de ventanas ni la barra lateral.
require('mini.bufremove').setup()

-- Sin LSP, parsers adicionales, autocompletado, snippets ni formato automático.
-- Los añadiremos por necesidad, explicando cada cambio antes de activarlo.
