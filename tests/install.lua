-- Installer Regression Tests
-- Usa carpetas temporales; nunca carga LazyVim ni instala plugins.
local uv = vim.uv
local script = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p')
local root = vim.fs.dirname(vim.fs.dirname(script))
local base = vim.fn.tempname()
local project = base .. '/repo with spaces'
local files = { 'init.lua', 'plugin/10_options.lua', 'plugin/20_keymaps.lua', 'plugin/30_mini.lua', 'plugin/40_sidebar.lua' }
local read = function(path) return table.concat(vim.fn.readfile(path, 'b'), '\n') end
local write = function(path, text)
  vim.fn.mkdir(vim.fs.dirname(path), 'p')
  assert(vim.fn.writefile({ text }, path, 'b') == 0)
end
local copy = function(from, to)
  vim.fn.mkdir(vim.fs.dirname(to), 'p')
  assert(uv.fs_copyfile(from, to))
end
local run = function(appname, home)
  home = home or base
  return vim.system({ vim.v.progpath, '--clean', '-l', project .. '/scripts/install.lua' }, {
    env = {
      NVIM_APPNAME = appname,
      XDG_CONFIG_HOME = home .. '/config',
      XDG_DATA_HOME = home .. '/data',
      XDG_STATE_HOME = home .. '/state',
      XDG_CACHE_HOME = home .. '/cache',
      NVIM_LOG_FILE = home .. '/nvim.log',
    },
    text = true,
  }):wait(10000)
end

local test = function()
  for _, relative in ipairs(files) do copy(root .. '/learning/' .. relative, project .. '/learning/' .. relative) end
  copy(root .. '/scripts/install.lua', project .. '/scripts/install.lua')
  local normal = base .. '/config/nvim/init.lua'
  write(normal, '-- Normal profile must stay unchanged\n')
  assert(run('nvim').code ~= 0, 'No rechazó el perfil habitual.')

  local target = base .. '/config/nvim-learning'
  local first = run('nvim-learning')
  assert(first.code == 0, first.stderr)
  for _, relative in ipairs(files) do
    assert(read(target .. '/' .. relative) == read(project .. '/learning/' .. relative), relative)
  end
  assert(run('nvim-learning').code == 0, 'Reinstalación idéntica falló.')
  assert(not uv.fs_stat(target .. '/learning-backup'), 'Creó respaldo sin cambios.')

  -- Actualizar un perfil anterior de cuatro archivos agrega el quinto de forma segura.
  local sidebar = target .. '/plugin/40_sidebar.lua'
  local metadata = target .. '/.nvim-learning.json'
  local old_state = vim.json.decode(read(metadata))
  old_state.hashes['plugin/40_sidebar.lua'] = nil
  write(metadata, vim.json.encode(old_state))
  assert(uv.fs_unlink(sidebar))
  write(sidebar, '-- Foreign sidebar\n')
  assert(run('nvim-learning').code ~= 0, 'Sobrescribió una barra lateral ajena.')
  assert(read(sidebar) == '-- Foreign sidebar\n')
  assert(uv.fs_unlink(sidebar))
  assert(run('nvim-learning').code == 0, 'No migró el perfil de cuatro archivos.')
  assert(read(sidebar) == read(project .. '/learning/plugin/40_sidebar.lua'))
  assert(vim.json.decode(read(metadata)).hashes['plugin/40_sidebar.lua'] ~= nil)

  local options = target .. '/plugin/10_options.lua'
  local before = read(options)
  write(options, before .. '-- Local edit\n')
  assert(run('nvim-learning').code ~= 0, 'Sobrescribió una edición local.')
  assert(read(options) == before .. '-- Local edit\n', 'Perdió la edición local.')
  write(options, before)

  write(project .. '/learning/plugin/10_options.lua', before .. '-- Managed update\n')
  local update = run('nvim-learning')
  assert(update.code == 0, update.stderr)
  local backups = vim.fn.globpath(target .. '/learning-backup', '*/plugin/10_options.lua', false, true)
  assert(#backups == 1 and read(backups[1]) == before, 'Respaldo incorrecto.')
  assert(read(options) == before .. '-- Managed update\n', 'No copió la actualización.')
  write(target .. '/notes.txt', 'Unmanaged file\n')
  assert(run('nvim-learning').code == 0)
  assert(read(target .. '/notes.txt') == 'Unmanaged file\n', 'Borró un archivo ajeno.')

  local foreign = base .. '/foreign'
  write(foreign .. '/config/nvim-learning/init.lua', '-- Foreign profile\n')
  assert(run('nvim-learning', foreign).code ~= 0, 'Aceptó un perfil ajeno.')
  assert(read(foreign .. '/config/nvim-learning/init.lua') == '-- Foreign profile\n')

  local linked = base .. '/linked'
  vim.fn.mkdir(linked .. '/config', 'p')
  assert(uv.fs_symlink(foreign .. '/config/nvim-learning', linked .. '/config/nvim-learning'))
  assert(run('nvim-learning', linked).code ~= 0, 'Aceptó un enlace simbólico de destino.')
  assert(uv.fs_rename(target .. '/plugin', target .. '/saved-plugin'))
  assert(uv.fs_symlink(foreign .. '/config/nvim-learning', target .. '/plugin'))
  assert(run('nvim-learning').code ~= 0, 'Aceptó un enlace simbólico en plugin/.')
  assert(read(normal) == '-- Normal profile must stay unchanged\n', 'Cambió el perfil habitual.')
end

local ok, err = pcall(test)
if not ok then
  io.stderr:write(tostring(err) .. '\nFixture para revisar: ' .. base .. '\n')
  vim.cmd('cquit 1')
end
vim.fn.delete(base, 'rf')
print('OK: instalación, idempotencia, respaldo, cambios locales, archivos ajenos y enlaces protegidos.')
