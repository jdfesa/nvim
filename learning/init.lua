-- Learning Profile
-- Se ejecuta primero. Después Neovim carga plugin/*.lua en orden alfabético.
-- Este perfil usa la estructura de MiniMax y navegación preparada para practicar.
if vim.env.NVIM_APPNAME ~= 'nvim-learning' then
  error('Abrí este perfil con NVIM_APPNAME=nvim-learning; no reemplaces LazyVim.')
end
if vim.fn.has('nvim-0.11.3') ~= 1 then
  error('Este perfil necesita Neovim 0.11.3 o superior para nvim-lspconfig.')
end

vim.g.learning_profile = true
-- Cambiar a false permite desactivar completion y LSP sin borrar sus datos.
vim.g.learning_web_tools = true
vim.g.mapleader = ' '
-- La barra lateral reemplaza netrw solo dentro de este perfil aislado.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Dependency Bootstrap
-- MINI está fijado a una revisión estable; la barra lateral se prepara en 40_sidebar.lua.
-- stdpath evita rutas personales y separa los datos de los de LazyVim.
local revision = '1345d191bb3da9c7b0e977f4387c5761f9bff68d'
local origin = 'https://github.com/nvim-mini/mini.nvim.git'
local mini_path = vim.fn.stdpath('data') .. '/site/pack/deps/start/mini.nvim'
local uv = vim.uv
local git = function(args)
  local result = vim.fn.system(args)
  if vim.v.shell_error ~= 0 then error('Git falló:\n' .. result) end
  return vim.trim(result)
end

if vim.fn.executable('git') ~= 1 then error('Necesitás Git en PATH para mini.nvim.') end
if not uv.fs_stat(mini_path) then
  -- Clonar primero en una carpeta temporal evita cargar una descarga incompleta.
  local staging = mini_path .. '.installing'
  if uv.fs_stat(staging) then
    error('Hay una instalación incompleta; revisá esta carpeta antes de reintentar: ' .. staging)
  end
  vim.fn.mkdir(vim.fs.dirname(mini_path), 'p')
  git({ 'git', 'clone', '--filter=blob:none', '--branch', 'v0.18.0', origin, staging })
  git({ 'git', '-C', staging, 'checkout', '--detach', revision })
  assert(uv.fs_rename(staging, mini_path))
end

-- Comprobar el pin también en instalaciones existentes: MiniDeps.add no lo aplica.
if git({ 'git', '-C', mini_path, 'rev-parse', 'HEAD' }) ~= revision then
  error('La revisión de mini.nvim no coincide con el pin. Revisá docs/06-learning-profile.md.')
end
vim.cmd('packadd mini.nvim')

-- Plugin Management
-- Usamos mini.deps, como la referencia MiniMax 0.11, sin lazy.nvim ni LazyVim.
-- No hay actualizaciones automáticas; el checkout fijo conserva esta revisión.
require('mini.deps').setup()
MiniDeps.add({ name = 'mini.nvim', source = origin, checkout = revision })

-- Documentation
-- Los tags permiten abrir :help MiniPick, :help MiniStatusline y :help MiniBufremove.
if vim.fn.filereadable(mini_path .. '/doc/tags') == 0 then
  vim.cmd('helptags ' .. vim.fn.fnameescape(mini_path .. '/doc'))
end
