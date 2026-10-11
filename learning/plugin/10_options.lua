-- Editor Options
-- vim.o cambia opciones del editor. :help 'number' explica una opción concreta.
vim.o.number = true -- Mostrar el número real en la línea actual.
vim.o.relativenumber = true -- Las otras líneas muestran distancias para practicar 5j, 3k, etc.
vim.o.cursorline = true -- Distinguir la línea donde está el cursor.
vim.o.scrolloff = 4 -- Mantener unas líneas de contexto al desplazarse.
vim.o.wrap = false -- No dividir visualmente líneas largas.
vim.o.termguicolors = true -- Colores reales si la terminal los soporta.
vim.o.signcolumn = 'yes' -- Evitar saltos al aparecer signos en el margen.
vim.o.splitbelow = true -- Abrir divisiones horizontales debajo.
vim.o.splitright = true -- Abrir divisiones verticales a la derecha.
vim.o.showtabline = 1 -- Mostrar pestañas cuando haya más de una; no son una lista de archivos.

-- Editing and Search
vim.o.expandtab = true -- Insertar espacios en lugar de tabuladores.
vim.o.tabstop = 2 -- Mostrar un tabulador como dos columnas.
vim.o.shiftwidth = 2 -- Indentar de a dos espacios.
vim.o.autoindent = true -- Mantener la indentación al crear otra línea.
vim.o.ignorecase = true -- Buscar sin distinguir mayúsculas.
vim.o.smartcase = true -- Distinguirlas si la búsqueda contiene una mayúscula.
vim.o.undofile = true -- Conservar historial de deshacer en el estado de este perfil.

-- Appearance
-- Tema incluido en Neovim: no agrega otra dependencia.
vim.cmd.colorscheme('habamax')
