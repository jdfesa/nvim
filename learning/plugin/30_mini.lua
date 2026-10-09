-- MINI Modules
-- Descargar mini.nvim no activa todos sus módulos: cada setup activa solo uno.
-- Sin iconos especiales: no hace falta una Nerd Font para este primer perfil.
require('mini.files').setup({
  content = { prefix = function() end },
  options = {
    -- Abrir solo con nuestro atajo; no sustituir todavía el explorador nativo.
    use_as_default_explorer = false,
    -- Los borrados van a la papelera propia del módulo, no se eliminan definitivamente.
    permanent_delete = false,
  },
})
require('mini.pick').setup()
require('mini.statusline').setup({ use_icons = false })

-- Sin LSP, parsers adicionales, autocompletado, snippets ni formato automático.
-- Los añadiremos por necesidad, explicando cada cambio antes de activarlo.
