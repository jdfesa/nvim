-- Web Completion Integration
-- Ejecutar después del arranque real; solo edita fixtures temporales.
local fixture = vim.fn.tempname()
local script = vim.fn.fnamemodify(debug.getinfo(1, 'S').source:sub(2), ':p')
local root = vim.fs.dirname(vim.fs.dirname(script))
local test = function()
  assert(vim.g.learning_web_tools == true and vim.g.learning_profile == true)
  assert(vim.v.errmsg == '', vim.v.errmsg)
  assert(_G.MiniCompletion == nil and _G.MiniSnippets == nil, 'Hay dos motores de completion.')
  require('blink.cmp')
  local config = require('blink.cmp.config')
  assert(config.keymap.preset == 'enter' and config.snippets.preset == 'default')
  assert(vim.deep_equal(config.sources.default, { 'lsp', 'path', 'snippets', 'buffer' }))
  assert(config.completion.menu.auto_show and config.completion.documentation.auto_show)
  assert(vim.wait(15000, function()
    return vim.fn.maparg('<C-y>', 'c', false, true).desc ~= nil
  end, 50), 'Blink no terminó de iniciar.')

  local registry = require('mason-registry')
  for _, name in ipairs({ 'html-lsp', 'css-lsp', 'vtsls' }) do
    assert(registry.has_package(name) and registry.get_package(name):is_installed(), 'Falta servidor: ' .. name)
  end
  assert(require('mason.settings').current.install_root_dir == vim.fn.stdpath('data') .. '/mason')
  local versions = { ['html-lsp'] = '4.10.0', ['css-lsp'] = '4.10.0', vtsls = '0.3.0' }
  for name, version in pairs(versions) do
    local path = vim.fn.stdpath('data') .. '/mason/packages/' .. name .. '/mason-receipt.json'
    local receipt = vim.json.decode(table.concat(vim.fn.readfile(path), '\n'))
    assert(receipt.schema_version == '2.0' and receipt.source.id:find('@' .. version, 1, true),
      'Versión o receipt distinto: ' .. name)
  end

  -- Los mapas del plugin se aplican localmente al entrar en Insert, no son globales.
  vim.fn.mkdir(fixture, 'p')
  local expected_maps = {}
  for _, line in ipairs(vim.fn.readfile(root .. '/KEYMAPS.md')) do
    local cells = vim.split(line, '|', { plain = true })
    if #cells == 6 then
      local key = vim.trim(cells[2]):match('^`([^`]+)`$')
      local scope = vim.trim(cells[5])
      if key and (scope == 'Completion' or scope == 'Commandline') then
        for _, mode in ipairs(vim.split(vim.trim(cells[4]), ',', { plain = true })) do
          expected_maps[vim.trim(mode) .. ':' .. vim.api.nvim_replace_termcodes(key, true, true, true)] = true
        end
      end
    end
  end
  assert(vim.tbl_count(expected_maps) > 0, 'Falta documentación de completion.')
  vim.api.nvim_exec_autocmds('InsertEnter', { buffer = 0 })
  local actual_maps = {}
  for _, mode in ipairs({ 'i', 's', 'c' }) do
    local maps = mode == 'c' and vim.api.nvim_get_keymap(mode) or vim.api.nvim_buf_get_keymap(0, mode)
    for _, mapping in ipairs(maps) do
      if mapping.desc and vim.startswith(mapping.desc, 'blink.cmp: ') then
        local id = mode .. ':' .. vim.api.nvim_replace_termcodes(mapping.lhs, true, true, true)
        assert(expected_maps[id], 'Mapa de Blink no documentado: ' .. mode .. ' ' .. mapping.lhs)
        actual_maps[id] = true
      end
    end
  end
  for id in pairs(expected_maps) do assert(actual_maps[id], 'Mapa documentado no activo: ' .. id) end

  for _, sample in ipairs({
    { 'index.html', 'html', { '<di' }, 0, 3, 'div' },
    { 'styles.css', 'cssls', { 'body {', '  col', '}' }, 1, 5, 'color' },
    { 'main.js', 'vtsls', { 'const greeting = "hello";', 'greeting.toU' }, 1, 12, 'toUpperCase' },
  }) do
    local path = fixture .. '/' .. sample[1]
    vim.fn.writefile(sample[3], path)
    vim.cmd('edit ' .. vim.fn.fnameescape(path))
    local buffer = vim.api.nvim_get_current_buf()
    local client
    assert(vim.wait(30000, function()
      client = vim.lsp.get_clients({ bufnr = buffer, name = sample[2] })[1]
      return client and client.initialized
    end, 50), 'No se adjuntó: ' .. sample[2])
    assert(client.config.capabilities.textDocument.completion.completionItem.snippetSupport)
    local params = {
      textDocument = { uri = vim.uri_from_bufnr(buffer) },
      position = { line = sample[4], character = sample[5] },
      context = { triggerKind = 1 },
    }
    local found = false
    for _ = 1, 10 do
      local reply = client:request_sync('textDocument/completion', params, 10000, buffer)
      assert(reply and not reply.err, 'Falló completion de ' .. sample[2])
      for _, item in ipairs(reply.result and (reply.result.items or reply.result) or {}) do
        if item.label == sample[6] then found = true end
      end
      if found then break end
      vim.wait(500)
    end
    assert(found, sample[2] .. ' no sugirió ' .. sample[6])
  end
  local plain = fixture .. '/excluded.ts'
  vim.fn.writefile({ 'const value = 1;' }, plain)
  vim.cmd('edit ' .. vim.fn.fnameescape(plain))
  vim.wait(500)
  assert(#vim.lsp.get_clients({ bufnr = 0 }) == 0, 'Se habilitó otro lenguaje sin pedirlo.')
  assert(vim.v.errmsg == '', vim.v.errmsg)
end

local ok, err = pcall(test)
for _, client in ipairs(vim.lsp.get_clients()) do client:stop(true) end
vim.fn.delete(fixture, 'rf')
if not ok then
  io.stderr:write(tostring(err) .. '\n')
  vim.cmd('cquit 1')
end
print('OK: Blink, mapas documentados, versiones aisladas y completion LSP HTML/CSS/JavaScript.')
print('Prueba headless de integración; el menú al escribir se verifica por separado en PTY.')
