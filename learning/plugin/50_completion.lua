-- LazyVim Completion
-- El mismo motor y colección del LazyVim observado, sin cargar la distribución.
if vim.g.learning_web_tools == false then return end

local dependencies = {
  { 'friendly-snippets', 'rafamadriz/friendly-snippets', '6cd7280adead7f586db6fccbd15d2cac7e2188b9' },
  { 'blink.cmp', 'saghen/blink.cmp', '78336bc89ee5365633bcf754d93df01678b5c08f' }, -- v1.10.2
}
for _, dependency in ipairs(dependencies) do
  local name, source, revision = unpack(dependency)
  MiniDeps.add({ name = name, source = 'https://github.com/' .. source .. '.git', checkout = revision })
  local path = MiniDeps.config.path.package .. '/pack/deps/opt/' .. name
  local head = vim.fn.system({ 'git', '-C', path, 'rev-parse', 'HEAD' })
  if vim.v.shell_error ~= 0 or vim.trim(head) ~= revision then
    error('La revisión de ' .. name .. ' no coincide con el pin. Revisá docs/languages/web.md.')
  end
end

require('blink.cmp').setup({
  -- Preset enter de LazyVim: Enter acepta; Tab recorre campos, no acepta el menú.
  keymap = { preset = 'enter', ['<C-y>'] = { 'select_and_accept' } },
  snippets = { preset = 'default' }, -- Usa vim.snippet, incluido en Neovim.
  sources = { default = { 'lsp', 'path', 'snippets', 'buffer' } },
  completion = {
    accept = { auto_brackets = { enabled = true } },
    -- Texto en vez de iconos: misma interacción, sin exigir Nerd Font ni parsers.
    menu = { draw = { columns = { { 'label', 'label_description', gap = 1 }, { 'kind' } } } },
    documentation = { auto_show = true, auto_show_delay_ms = 200 },
    ghost_text = { enabled = false }, -- No instalamos asistentes de IA.
  },
  -- Blink descarga/verifica el binario de este release; no requiere instalar Rust.
  fuzzy = { prebuilt_binaries = { force_version = 'v1.10.2' } },
  cmdline = {
    enabled = true,
    keymap = { preset = 'cmdline', ['<Right>'] = false, ['<Left>'] = false },
    completion = {
      list = { selection = { preselect = false } },
      menu = { auto_show = function() return vim.fn.getcmdtype() == ':' end },
      ghost_text = { enabled = true },
    },
  },
})
