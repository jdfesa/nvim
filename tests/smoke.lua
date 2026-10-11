-- Learning Profile Smoke Test
-- Se ejecuta DESPUÉS del arranque real, con -c 'luafile tests/smoke.lua', no con --clean.
local fixture = vim.fn.tempname()
local test = function()
  assert(vim.env.NVIM_APPNAME == 'nvim-learning', 'Perfil incorrecto.')
  assert(vim.g.learning_profile == true, 'No cargó nuestro init.lua.')
  assert(vim.v.errmsg == '', 'Error durante arranque: ' .. vim.v.errmsg)
  for _, kind in ipairs({ 'config', 'data', 'state', 'cache' }) do
    assert(vim.fs.basename(vim.fn.stdpath(kind)) == 'nvim-learning', 'Ruta compartida: ' .. kind)
  end
  for _, name in ipairs({ 'MiniDeps', 'MiniPick', 'MiniStatusline', 'MiniBufremove' }) do
    assert(type(_G[name]) == 'table', 'Falta módulo: ' .. name)
  end
  for _, name in ipairs({ 'MiniFiles', 'MiniStarter', 'MiniSessions', 'MiniCompletion', 'MiniSnippets' }) do
    assert(_G[name] == nil, 'Módulo no previsto: ' .. name)
  end
  for _, keys in ipairs({
    '<Leader>e', '<Leader>fe', '<Leader>ff', '<Leader>fn', '<Leader>sg',
    '<Leader>fg', '<Leader>fb', '<Leader>fh', '<Leader>sh', '<Leader>,',
    '<Leader>bd', '<C-h>', '<C-j>', '<C-k>', '<C-l>', '<C-s>',
    '<Leader>-', '<Leader>|', '<Leader>wd', '<Leader>qq',
    '<Leader><Tab><Tab>', '<Leader><Tab>]', '<Leader><Tab>[',
    '<Leader><Tab>d', '<Leader>uL', '<Leader>uw',
  }) do
    assert(vim.fn.maparg(keys, 'n') ~= '', 'Falta atajo: ' .. keys)
  end
  assert(vim.g.mapleader == ' ' and vim.o.number and vim.o.relativenumber and vim.o.undofile)
  assert(vim.o.shiftwidth == 2 and vim.o.expandtab)
  assert(vim.g.colors_name == 'habamax')
  assert(#vim.lsp.get_clients() == 0, 'Hay un servidor LSP no previsto.')

  -- Abrir y guardar tres archivos de prueba; no se modifican ejercicios del usuario.
  vim.fn.mkdir(fixture, 'p')
  for _, sample in ipairs({
    { 'index.html', 'html', '<h1>Hello</h1>' },
    { 'styles.css', 'css', 'h1 { color: teal; }' },
    { 'main.js', 'javascript', 'console.log("Hello");' },
  }) do
    local path = fixture .. '/' .. sample[1]
    vim.fn.writefile({ sample[3] }, path)
    vim.cmd('edit ' .. vim.fn.fnameescape(path))
    assert(vim.bo.filetype == sample[2], 'Filetype incorrecto: ' .. sample[1])
    vim.api.nvim_buf_set_lines(0, -1, -1, false, { '' })
    vim.cmd('silent write')
    assert(vim.fn.readfile(path)[1] == sample[3], 'No guardó: ' .. sample[1])
  end
  -- Probar los atajos mismos, no solo que exista su definición.
  local press = function(keys)
    local codes = vim.api.nvim_replace_termcodes(keys, true, false, true)
    vim.api.nvim_feedkeys(codes, 'xt', false)
  end
  press('<Space>uL')
  assert(not vim.wo.relativenumber, 'No apagó números relativos.')
  press('<Space>uL')
  assert(vim.wo.relativenumber, 'No encendió números relativos.')

  vim.api.nvim_buf_set_lines(0, -1, -1, false, { '// Save shortcut fixture' })
  press('<C-s>')
  assert(not vim.bo.modified, 'Ctrl-s no guardó el archivo.')
  assert(vim.fn.readfile(fixture .. '/main.js')[3] == '// Save shortcut fixture')

  local api = require('nvim-tree.api')
  assert(not api.tree.is_visible(), 'La barra no debe abrirse automáticamente.')
  vim.cmd('cd ' .. vim.fn.fnameescape(fixture))
  local editing_window = vim.api.nvim_get_current_win()
  local edited_buffer = vim.api.nvim_get_current_buf()
  press('<Space>e')
  assert(api.tree.is_visible(), 'No abrió la barra lateral.')
  local sidebar_window = vim.api.nvim_get_current_win()
  assert(vim.bo.filetype == 'NvimTree', 'No enfocó la barra lateral.')
  assert(vim.fn.wincol() >= 1 and #vim.api.nvim_list_wins() == 2)
  assert(vim.api.nvim_win_get_position(sidebar_window)[2] < vim.api.nvim_win_get_position(editing_window)[2])
  assert(vim.fn.maparg('<C-k>', 'n', false, true).buffer == 0, 'La barra pisa la navegación Ctrl-k.')
  local sidebar_maps = vim.api.nvim_buf_get_keymap(0, 'n')
  for _, mapping in ipairs(sidebar_maps) do
    assert(mapping.lhs ~= 'd' and mapping.lhs ~= '<Del>', 'Hay un atajo de borrado de archivos.')
  end
  press('<C-l>')
  assert(vim.api.nvim_get_current_win() == editing_window, 'Ctrl-l no volvió al archivo.')
  press('<C-h>')
  assert(vim.api.nvim_get_current_win() == sidebar_window, 'Ctrl-h no volvió a la barra.')
  api.tree.find_file({ open = true, focus = true, buf = edited_buffer })
  press('<CR>')
  assert(api.tree.is_visible(), 'Abrir archivo cerró la barra.')
  assert(vim.api.nvim_get_current_buf() == edited_buffer, 'No abrió el archivo seleccionado.')
  press('<Space>e')
  assert(not api.tree.is_visible(), 'No cerró la barra lateral.')

  local windows = #vim.api.nvim_tabpage_list_wins(0)
  press('<Space>|')
  assert(#vim.api.nvim_tabpage_list_wins(0) == windows + 1, 'No creó split.')
  press('<Space>wd')
  assert(#vim.api.nvim_tabpage_list_wins(0) == windows, 'No cerró split.')
  press('<Space><Tab><Tab>')
  assert(#vim.api.nvim_list_tabpages() == 2, 'No creó pestaña.')
  press('<Space><Tab>[')
  assert(vim.fn.tabpagenr() == 1, 'No cambió a pestaña anterior.')
  press('<Space><Tab>]')
  assert(vim.fn.tabpagenr() == 2, 'No cambió a pestaña siguiente.')
  press('<Space><Tab>d')
  assert(#vim.api.nvim_list_tabpages() == 1, 'No cerró pestaña.')
  press('<Space><Tab>d')
  assert(#vim.api.nvim_list_tabpages() == 1, 'La última pestaña no debe cerrarse.')

  press('<Space>bd')
  assert(not vim.bo[edited_buffer].buflisted, 'No cerró buffer.')
  assert(#vim.api.nvim_list_wins() == windows, 'Cerrar buffer destruyó ventanas.')

  press('<Space>fn')
  local unsaved = vim.api.nvim_get_current_buf()
  assert(vim.api.nvim_buf_get_name(unsaved) == '', 'El archivo nuevo ya tiene un nombre.')
  vim.api.nvim_buf_set_lines(unsaved, 0, -1, false, { 'Unsaved fixture' })
  local confirm = vim.fn.confirm
  local confirmations = 0
  vim.fn.confirm = function()
    confirmations = confirmations + 1
    return 3 -- Cancelar: no aceptar el borrado del buffer modificado.
  end
  local canceled, cancel_error = pcall(press, '<Space>bd')
  vim.fn.confirm = confirm
  assert(canceled, cancel_error)
  assert(confirmations == 1 and vim.bo[unsaved].buflisted and vim.bo[unsaved].modified)
  assert(vim.api.nvim_buf_get_lines(unsaved, 0, -1, false)[1] == 'Unsaved fixture', 'Perdió cambios sin guardar.')
  vim.api.nvim_buf_delete(unsaved, { force = true }) -- Solo la fixture temporal que acabamos de crear.
  assert(vim.v.errmsg == '', 'Error durante navegación: ' .. vim.v.errmsg)
end
local ok, err = pcall(test)
vim.fn.delete(fixture, 'rf')
if not ok then
  io.stderr:write(tostring(err) .. '\n')
  vim.cmd('cquit 1')
end
print('OK: perfil aislado, barra lateral, números relativos, buffers, splits, pestañas y edición web.')
print('Prueba headless: no sustituye inspección visual ni ejecución en otro sistema.')
