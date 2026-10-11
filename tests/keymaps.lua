-- Keymap Documentation Regression Test
-- Desde la raíz: rtk proxy nvim --headless --clean -l tests/keymaps.lua
-- Captura definiciones en un entorno simulado: no descarga plugins ni ejecuta acciones.
local script = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p')
local root = vim.fs.dirname(vim.fs.dirname(script))
local actual, documented = {}, {}
local normalize = function(keys)
  keys = keys:gsub('<[Ll]eader>', '<Space>'):gsub('\\|', '<Bar>')
  return vim.api.nvim_replace_termcodes(keys, true, true, true)
end
local identity = function(keys, mode, scope)
  return scope .. ':' .. mode .. ':' .. normalize(keys)
end
local add = function(target, keys, mode, scope)
  local id = identity(keys, mode, scope)
  assert(not target[id], 'Atajo duplicado: ' .. scope .. ' ' .. mode .. ' ' .. keys)
  target[id] = scope .. ' ' .. mode .. ' ' .. keys
end

local test = function()
  local revision, sidebar_setup
  local noop = function() end
  local api = {
    node = {
      open = { edit = noop, vertical = noop, horizontal = noop, tab = noop },
      navigate = { parent_close = noop },
    },
    tree = { close = noop, toggle_help = noop, reload = noop },
    fs = { create = noop },
  }
  local environment = setmetatable({
    vim = {
      keymap = {
        set = function(modes, keys, action, options)
          assert(type(action) == 'string' or type(action) == 'function', 'Acción inválida: ' .. keys)
          assert(type(options.desc) == 'string' and options.desc ~= '', 'Falta desc: ' .. keys)
          if type(modes) == 'string' then modes = { modes } end
          local scope = options.buffer ~= nil and 'Sidebar' or 'Global'
          for _, mode in ipairs(modes) do add(actual, keys, mode, scope) end
        end,
      },
      fn = {
        -- Simular la comprobación del checkout y tags, sin llamar Git ni escribir archivos.
        system = function() return assert(revision) end,
        filereadable = function() return 1 end,
      },
      v = { shell_error = 0 },
      trim = vim.trim,
    },
    MiniDeps = {
      config = { path = { package = '/mock' } },
      add = function(spec) revision = spec.checkout end,
    },
    require = function(name)
      if name == 'nvim-tree.api' then return api end
      assert(name == 'nvim-tree', 'Dependencia no simulada: ' .. name)
      return { setup = function(options) sidebar_setup = options end }
    end,
  }, { __index = _G })

  for _, path in ipairs({ '20_keymaps.lua', '40_sidebar.lua' }) do
    local chunk = assert(loadfile(root .. '/learning/plugin/' .. path))
    setfenv(chunk, environment)()
  end
  assert(sidebar_setup and type(sidebar_setup.on_attach) == 'function', 'Falta on_attach de la barra.')
  sidebar_setup.on_attach(1)

  -- Una fila por tecla, con columnas Key, Action, Mode, Scope.
  -- El símbolo | escapado se normaliza antes de separar las celdas Markdown.
  for _, line in ipairs(vim.fn.readfile(root .. '/KEYMAPS.md')) do
    local cells = vim.split(line:gsub('\\|', '<Bar>'), '|', { plain = true })
    if #cells == 6 then
      local keys = vim.trim(cells[2]):match('^`([^`]+)`$')
      local modes, scope = vim.trim(cells[4]), vim.trim(cells[5])
      if keys and (scope == 'Global' or scope == 'Sidebar') then
        assert(vim.trim(cells[3]) ~= '', 'Falta Action: ' .. keys)
        for _, mode in ipairs(vim.split(modes, ',', { plain = true })) do
          add(documented, keys, vim.trim(mode), scope)
        end
      end
    end
  end
  assert(vim.tbl_count(actual) > 0 and vim.tbl_count(documented) > 0, 'No se encontraron atajos.')
  for id, label in pairs(actual) do assert(documented[id], 'Falta documentar: ' .. label) end
  for id, label in pairs(documented) do assert(actual[id], 'Documenta un atajo inexistente: ' .. label) end
end

local ok, err = pcall(test)
if not ok then
  io.stderr:write(tostring(err) .. '\n')
  vim.cmd('cquit 1')
end
print(string.format('OK: %d combinaciones de tecla, modo y alcance coinciden con KEYMAPS.md.', vim.tbl_count(actual)))
print('Solo definiciones propias: dependencias simuladas, sin probar acciones, picker ni interfaz.')
