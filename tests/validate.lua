-- Validación estática: compila Lua y lee JSON, no ejecuta la configuración.
-- Desde la raíz: rtk proxy nvim --headless --clean -l tests/validate.lua
local script = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p')
local root = vim.fs.dirname(vim.fs.dirname(script))
local failures = {}
local check_file = function(path)
  if vim.fn.filereadable(path) ~= 1 then
    failures[#failures + 1] = 'Falta archivo: ' .. path
  end
end

local lua_files = vim.fn.globpath(root .. '/configs', '**/*.lua', false, true)
lua_files[#lua_files + 1] = root .. '/setup.lua'
-- Compilar la referencia externa solo comprueba sintaxis; no ejecuta su init.
lua_files[#lua_files + 1] = root .. '/resources/nvim-lite-pluginless/init.lua'
for _, directory in ipairs({ 'learning', 'scripts', 'tests' }) do
  vim.list_extend(lua_files, vim.fn.globpath(root .. '/' .. directory, '**/*.lua', false, true))
end
for _, path in ipairs(lua_files) do
  local chunk, err = loadfile(path)
  if not chunk then failures[#failures + 1] = path .. ': ' .. tostring(err) end
end

local json_files = vim.fn.globpath(root .. '/configs', '**/*.json', false, true)
for _, path in ipairs(json_files) do
  local ok, err = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(path), '\n'))
  end)
  if not ok then failures[#failures + 1] = path .. ': ' .. tostring(err) end
end

for _, version in ipairs({ '0.10', '0.11', '0.12', '0.13' }) do
  local profile = root .. '/configs/nvim-' .. version
  for _, name in ipairs({
    'init.lua',
    'plugin/10_options.lua',
    'plugin/20_keymaps.lua',
    'plugin/30_mini.lua',
    'plugin/40_plugins.lua',
    'snippets/global.json',
    'after/ftplugin/markdown.lua',
    'after/snippets/lua.json',
  }) do
    check_file(profile .. '/' .. name)
  end
  if version ~= '0.10' then check_file(profile .. '/after/lsp/lua_ls.lua') end
  if version == '0.12' or version == '0.13' then
    check_file(profile .. '/nvim-pack-lock.json')
  end
end

for _, path in ipairs({
  'AGENTS.md',
  '.gitattributes',
  'KEYMAPS.md',
  'README.md',
  'README.upstream.md',
  'ROADMAP.md',
  'docs/README.md',
  'docs/01-installation.md',
  'docs/02-file-map.md',
  'docs/03-workflow.md',
  'docs/04-journal.md',
  'docs/05-launch-and-profiles.md',
  'docs/06-learning-profile.md',
  'docs/07-navigation-and-keymaps.md',
  'docs/languages/web.md',
  'learning/init.lua',
  'learning/plugin/10_options.lua',
  'learning/plugin/20_keymaps.lua',
  'learning/plugin/30_mini.lua',
  'learning/plugin/40_sidebar.lua',
  'scripts/install.lua',
  'scripts/launch.sh',
  'tests/install.lua',
  'tests/keymaps.lua',
  'tests/smoke.lua',
  'tests/terminal.py',
  'resources/README.md',
  'resources/nvim-lite-pluginless/README.md',
  'resources/nvim-lite-pluginless/init.lua',
}) do
  check_file(root .. '/' .. path)
end

if #lua_files < 2 or #json_files == 0 then
  failures[#failures + 1] = 'No se encontraron suficientes archivos para validar.'
end
if #failures > 0 then
  io.stderr:write(table.concat(failures, '\n') .. '\n')
  vim.cmd('cquit 1')
end

print(string.format('OK: %d Lua, %d JSON y estructura de 4 perfiles.', #lua_files, #json_files))
print('Solo checks estáticos: sin ejecutar configuración, instalar plugins ni probar Arch.')
