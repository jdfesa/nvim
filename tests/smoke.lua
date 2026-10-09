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
  for _, name in ipairs({ 'MiniDeps', 'MiniFiles', 'MiniPick', 'MiniStatusline' }) do
    assert(type(_G[name]) == 'table', 'Falta módulo: ' .. name)
  end
  for _, name in ipairs({ 'MiniStarter', 'MiniSessions', 'MiniCompletion', 'MiniSnippets' }) do
    assert(_G[name] == nil, 'Módulo no previsto: ' .. name)
  end
  for _, keys in ipairs({ '<Leader>ed', '<Leader>ff', '<Leader>fg', '<Leader>fb', '<Leader>fh' }) do
    assert(vim.fn.maparg(keys, 'n') ~= '', 'Falta atajo: ' .. keys)
  end
  assert(vim.g.mapleader == ' ' and vim.o.number and vim.o.undofile)
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
  MiniFiles.open(fixture, false)
  assert(type(MiniFiles.get_explorer_state()) == 'table', 'No abrió explorador.')
  assert(MiniFiles.close(), 'No cerró explorador.')
end
local ok, err = pcall(test)
vim.fn.delete(fixture, 'rf')
if not ok then
  io.stderr:write(tostring(err) .. '\n')
  vim.cmd('cquit 1')
end
print('OK: perfil aislado, módulos, atajos, explorador y edición HTML/CSS/JavaScript.')
print('Prueba headless macOS; uso visual interactivo y Arch pendientes.')
