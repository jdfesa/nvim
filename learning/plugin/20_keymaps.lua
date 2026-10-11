-- Practice Keymaps
-- <Leader> es Espacio. Se pulsan las teclas en secuencia, desde modo Normal.
-- Compartimos acciones con LazyVim, no sus plugins ni toda su configuración.
local map = function(keys, action, description)
  vim.keymap.set('n', keys, action, { desc = description, silent = true })
end

-- Files and Search
map('<Leader>e', function() require('nvim-tree.api').tree.toggle() end, 'Toggle Sidebar')
map('<Leader>fe', function() require('nvim-tree.api').tree.toggle() end, 'Toggle Sidebar')
map('<Leader>ff', function() MiniPick.builtin.files() end, 'Find Files')
map('<Leader>fn', '<Cmd>enew<CR>', 'New File')
local find_text = function()
  if vim.fn.executable('rg') ~= 1 then
    vim.notify('Para buscar texto necesitás ripgrep (rg) en PATH.', vim.log.levels.WARN)
    return
  end
  MiniPick.builtin.grep_live({ tool = 'rg' })
end
map('<Leader>sg', find_text, 'Find Text')
-- Alias anterior: en LazyVim <Leader>fg busca archivos Git, no texto.
map('<Leader>fg', find_text, 'Find Text (Legacy Alias)')
map('<Leader>sh', function() MiniPick.builtin.help() end, 'Find Help')
map('<Leader>fh', function() MiniPick.builtin.help() end, 'Find Help (Legacy Alias)')
map('<Esc>', '<Cmd>nohlsearch<CR>', 'Clear Search Highlight')
vim.keymap.set({ 'n', 'i', 'x' }, '<C-s>', '<Esc><Cmd>write<CR>', { desc = 'Save File', silent = true })
map('<Leader>qq', '<Cmd>qa<CR>', 'Quit All') -- Sin !: no descartar cambios sin guardar.

-- Buffers
-- Un buffer es un archivo abierto, aunque ninguna ventana lo muestre.
map('<Leader>fb', function() MiniPick.builtin.buffers() end, 'Find Buffers')
map('<Leader>,', function() MiniPick.builtin.buffers() end, 'Find Buffers')
map('<S-h>', '<Cmd>bprevious<CR>', 'Previous Buffer')
map('<S-l>', '<Cmd>bnext<CR>', 'Next Buffer')
map('[b', '<Cmd>bprevious<CR>', 'Previous Buffer')
map(']b', '<Cmd>bnext<CR>', 'Next Buffer')
map('<Leader>bb', '<Cmd>buffer #<CR>', 'Other Buffer')
map('<Leader>bd', function()
  if vim.bo.buftype ~= '' then
    vim.notify('Este no es un archivo editable; en la barra lateral usá q para cerrarla.')
    return
  end
  MiniBufremove.delete(0, false) -- Pedir confirmación si hay cambios sin guardar.
end, 'Delete Buffer')

-- Windows
-- Una ventana muestra un buffer; un split permite ver dos archivos a la vez.
map('<C-h>', '<C-w>h', 'Left Window')
map('<C-j>', '<C-w>j', 'Lower Window')
map('<C-k>', '<C-w>k', 'Upper Window')
map('<C-l>', '<C-w>l', 'Right Window')
map('<Leader>-', '<C-w>s', 'Split Below')
map('<Leader>|', '<C-w>v', 'Split Right')
map('<Leader>wd', '<C-w>c', 'Close Window')

-- Tab Pages
-- Una pestaña contiene una distribución de ventanas, no necesariamente un solo archivo.
map('<Leader><Tab><Tab>', '<Cmd>tabnew<CR>', 'New Tab')
map('<Leader><Tab>]', '<Cmd>tabnext<CR>', 'Next Tab')
map('<Leader><Tab>[', '<Cmd>tabprevious<CR>', 'Previous Tab')
map('<Leader><Tab>f', '<Cmd>tabfirst<CR>', 'First Tab')
map('<Leader><Tab>l', '<Cmd>tablast<CR>', 'Last Tab')
map('<Leader><Tab>d', function()
  if #vim.api.nvim_list_tabpages() == 1 then
    vim.notify('Es la última pestaña: usá <Leader>bd para cerrar el archivo o :q para salir.')
    return
  end
  vim.cmd('tabclose') -- Sin !: conservar las protecciones para cambios sin guardar.
end, 'Close Tab')

-- Display Toggles
map('<Leader>uL', function() vim.wo.relativenumber = not vim.wo.relativenumber end, 'Toggle Relative Numbers')
map('<Leader>uw', function() vim.wo.wrap = not vim.wo.wrap end, 'Toggle Wrap')
