-- Web Language Servers
-- Las capas de instalación y LSP de LazyVim, limitadas a nuestro primer bloque.
if vim.g.learning_web_tools == false then return end

local dependencies = {
  { 'nvim-lspconfig', 'neovim/nvim-lspconfig', 'd224a1920728ba129880efc700d4a0180ac4ecbb' },
  { 'mason.nvim', 'mason-org/mason.nvim', '2a6940af80375532e5e9e7c1f2fc6319a1b7a69d' },
  { 'mason-lspconfig.nvim', 'mason-org/mason-lspconfig.nvim', '47059d71b42d74b0a1e9f61c1d99d301039c3b5b' },
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

-- stdpath mantiene paquetes, ejecutables y registro separados de LazyVim.
require('mason').setup({ install_root_dir = vim.fn.stdpath('data') .. '/mason' })
local capabilities = require('blink.cmp').get_lsp_capabilities()
vim.lsp.config('html', {
  capabilities = capabilities,
  init_options = { provideFormatter = false },
})
vim.lsp.config('cssls', {
  capabilities = capabilities,
  filetypes = { 'css' },
  init_options = { provideFormatter = false },
})
vim.lsp.config('vtsls', {
  capabilities = capabilities,
  filetypes = { 'javascript' }, -- No activar TypeScript/React por instalar su motor.
  settings = {
    vtsls = { experimental = { completion = { enableServerSideFuzzyMatch = true } } },
    javascript = { suggest = { completeFunctionCalls = true } },
  },
})

-- Las versiones fijan nuevas instalaciones; Mason no actualiza paquetes ya presentes.
-- No instalar servidores de otros lenguajes ni habilitar todos los paquetes de Mason.
require('mason-lspconfig').setup({
  ensure_installed = { 'html@4.10.0', 'cssls@4.10.0', 'vtsls@0.3.0' },
  automatic_enable = { 'html', 'cssls', 'vtsls' },
})
