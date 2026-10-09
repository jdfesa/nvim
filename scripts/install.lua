-- Learning Profile Installer
-- Copia la fuente educativa al perfil aislado; no ejecuta su init ni instala plugins.
-- Desde la raíz: rtk proxy env NVIM_APPNAME=nvim-learning nvim --clean -l scripts/install.lua
local uv = vim.uv
local script = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p')
local root = vim.fs.dirname(vim.fs.dirname(script))
local source = root .. '/learning'
local target = vim.fn.stdpath('config')
local marker = '.nvim-learning.json'
local files = { 'init.lua', 'plugin/10_options.lua', 'plugin/20_keymaps.lua', 'plugin/30_mini.lua' }

local install = function()
  if vim.env.NVIM_APPNAME ~= 'nvim-learning' then
    error('Usá NVIM_APPNAME=nvim-learning. No instalaremos sobre el perfil habitual.')
  end
  if vim.fn.has('nvim-0.11') ~= 1 then error('Necesitás Neovim 0.11 o superior.') end

  -- No seguir enlaces dentro del destino: podrían escribir sobre otra configuración.
  local check_path = function(path, expected_type)
    local stat = uv.fs_lstat(path)
    if stat and stat.type ~= expected_type then
      error('Tipo de archivo inesperado o enlace simbólico: ' .. path)
    end
  end
  check_path(target, 'directory')
  check_path(target .. '/plugin', 'directory')
  check_path(target .. '/' .. marker, 'file')

  local read = function(path)
    return table.concat(vim.fn.readfile(path, 'b'), '\n')
  end
  local hash = function(path) return vim.fn.sha256(read(path)) end
  local previous = { appname = 'nvim-learning', format = 1, hashes = {} }
  if uv.fs_stat(target) then
    if not uv.fs_stat(target .. '/' .. marker) then
      error('El destino ya existe y no pertenece a este instalador: ' .. target)
    end
    previous = vim.json.decode(read(target .. '/' .. marker))
    if previous.appname ~= 'nvim-learning' or previous.format ~= 1 or type(previous.hashes) ~= 'table' then
      error('Metadatos del perfil inválidos; revisá el destino antes de continuar.')
    end
  end

  -- Revisar todos los archivos ANTES de escribir alguno.
  local next_state = { appname = 'nvim-learning', format = 1, hashes = {} }
  local changed = {}
  for _, relative in ipairs(files) do
    local from, to = source .. '/' .. relative, target .. '/' .. relative
    assert(vim.fn.filereadable(from) == 1, 'Falta fuente: ' .. from)
    check_path(to, 'file')
    next_state.hashes[relative] = hash(from)
    if uv.fs_stat(to) then
      local current = hash(to)
      if current ~= previous.hashes[relative] and current ~= next_state.hashes[relative] then
        error('Cambios locales o archivo ajeno: ' .. to .. '\nNo se sobrescribió nada. Trasladá el cambio a learning/ primero.')
      end
      if current ~= next_state.hashes[relative] then changed[#changed + 1] = relative end
    end
  end

  -- Guardar las versiones instaladas que cambiarán, fuera de plugin/.
  local backup
  if #changed > 0 then
    check_path(target .. '/learning-backup', 'directory')
    backup = target .. '/learning-backup/' .. os.date('%Y%m%d-%H%M%S') .. '-' .. uv.os_getpid()
    assert(not uv.fs_lstat(backup), 'El respaldo ya existe: ' .. backup)
    for _, relative in ipairs(changed) do
      local to = backup .. '/' .. relative
      vim.fn.mkdir(vim.fs.dirname(to), 'p')
      assert(uv.fs_copyfile(target .. '/' .. relative, to))
    end
    assert(uv.fs_copyfile(target .. '/' .. marker, backup .. '/' .. marker))
  end

  for _, relative in ipairs(files) do
    local from, to = source .. '/' .. relative, target .. '/' .. relative
    if not uv.fs_stat(to) or hash(to) ~= next_state.hashes[relative] then
      vim.fn.mkdir(vim.fs.dirname(to), 'p')
      assert(uv.fs_copyfile(from, to))
    end
  end
  local metadata = vim.json.encode(next_state)
  if not uv.fs_stat(target .. '/' .. marker) or read(target .. '/' .. marker) ~= metadata then
    assert(vim.fn.writefile({ metadata }, target .. '/' .. marker, 'b') == 0)
  end
  print('Perfil instalado: ' .. target)
  if backup then print('Respaldo: ' .. backup) end
  print('LazyVim no fue modificado. Para abrir: env NVIM_APPNAME=nvim-learning nvim (sin RTK)')
end

local ok, err = pcall(install)
if not ok then
  io.stderr:write(tostring(err) .. '\n')
  vim.cmd('cquit 1')
end
