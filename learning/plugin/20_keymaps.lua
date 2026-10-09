-- Keymaps
-- <Leader> es Espacio, definido en init.lua. Estos atajos son de modo Normal.
-- Neovim permite crear un atajo antes de cargar el módulo que se usará al pulsarlo.
local map = function(keys, action, description)
  vim.keymap.set('n', keys, action, { desc = description })
end

map('<Leader>ed', function() MiniFiles.open(vim.fn.getcwd()) end, 'Explore Directory')
map('<Leader>ff', function() MiniPick.builtin.files() end, 'Find Files')
map('<Leader>fg', function()
  if vim.fn.executable('rg') ~= 1 then
    vim.notify('Para buscar texto necesitás ripgrep (rg) en PATH.', vim.log.levels.WARN)
    return
  end
  MiniPick.builtin.grep_live({ tool = 'rg' })
end, 'Find Text')
map('<Leader>fb', function() MiniPick.builtin.buffers() end, 'Find Buffers')
map('<Leader>fh', function() MiniPick.builtin.help() end, 'Find Help')
map('<Esc>', '<Cmd>nohlsearch<CR>', 'Clear Search Highlight')
