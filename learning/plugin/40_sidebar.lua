-- Persistent Sidebar
-- Una dependencia concreta: árbol lateral, no un segundo entorno completo.
local revision = '531b807b8f0d6f75016a0ee1e0cd5ce2086e9d95' -- nvim-tree v1.18.0
MiniDeps.add({
  name = 'nvim-tree.lua',
  source = 'https://github.com/nvim-tree/nvim-tree.lua.git',
  checkout = revision,
})

-- MiniDeps no corrige el checkout de una instalación existente: comprobar el pin.
local tree_path = MiniDeps.config.path.package .. '/pack/deps/opt/nvim-tree.lua'
local head = vim.fn.system({ 'git', '-C', tree_path, 'rev-parse', 'HEAD' })
if vim.v.shell_error ~= 0 or vim.trim(head) ~= revision then
  error('La revisión de nvim-tree no coincide con el pin. Revisá docs/06-learning-profile.md.')
end
if vim.fn.filereadable(tree_path .. '/doc/tags') == 0 then
  vim.cmd('helptags ' .. vim.fn.fnameescape(tree_path .. '/doc'))
end

require('nvim-tree').setup({
  -- netrw ya está desactivado: no limpiar un grupo FileExplorer que no existe (E216).
  disable_netrw = true,
  hijack_netrw = false,
  -- Abrir a pedido con <Leader>e; si se pasa una carpeta al arrancar, mostrar su árbol.
  hijack_directories = { enable = true, auto_open = true },
  view = { side = 'left', width = 30 },
  git = { enable = false },
  -- Actualizar con R si cambia una carpeta desde fuera; no vigilar todo el árbol.
  filesystem_watchers = { enable = false },
  renderer = {
    add_trailing = true,
    icons = {
      show = {
        file = false, folder = false, folder_arrow = true, git = false,
        modified = false, diagnostics = false, bookmarks = false,
      },
      glyphs = { folder = { arrow_closed = '>', arrow_open = 'v' } },
    },
  },
  actions = {
    change_dir = { enable = false },
    open_file = { quit_on_open = false, window_picker = { enable = false } },
  },
  -- Solo navegación y creación: no agregar todavía atajos de borrado de archivos.
  on_attach = function(buffer)
    local api = require('nvim-tree.api')
    local map = function(keys, action, description)
      vim.keymap.set('n', keys, action, { buffer = buffer, desc = description, silent = true, nowait = true })
    end
    map('<CR>', api.node.open.edit, 'Open File or Directory')
    map('l', api.node.open.edit, 'Open File or Directory')
    map('h', api.node.navigate.parent_close, 'Close Directory')
    map('q', api.tree.close, 'Close Sidebar')
    map('g?', api.tree.toggle_help, 'Sidebar Help')
    map('R', api.tree.reload, 'Refresh Sidebar')
    map('a', api.fs.create, 'Create File or Directory')
    map('<C-v>', api.node.open.vertical, 'Open in Vertical Split')
    map('<C-x>', api.node.open.horizontal, 'Open in Horizontal Split')
    map('<C-t>', api.node.open.tab, 'Open in New Tab')
  end,
})
