-- ajuster de ui vscode
-- surround
-- easymotion
-- splits: leader and v y s
-- mover entre splits con: ctrl y direcciones
-- mover entre tabs con: tab
-- cerrar tab: leader + leader + q
-- cerrar todas las pestañas: leader + leader + Q
-- manejo de la termina, abrir nueva, abrir en la misma, cerrar, moverse entre ellas, volver al codigo.
-- apertura de la busqueda
-- verificar si el colapsado esta funcionando correctamente
-- scrolling correctamente
-- mostrar, ocultar el sidebar
-- ir al explorador de archivos, volver al codigo
-- mostrar el archivo sin salir del explorador y ocultar al moverse, o mostrar el otro al que nos movimos
-- abrir el archivo sin salir del explorador
-- abrir el archivo e ir a el directamente
-- buscar como hacer el rename de una declaracion apra que cambie en todo el codigo
local vscode = require('vscode')

-- Set space as the leader key
vim.g.mapleader = " "

-------------------------------
-- Exit insert mode with jk

vim.keymap.set('i', 'jk', '<Esc>', {
    desc = 'Exit insert mode with jk'
})

--[[ vim.keymap.set('t', 'jk', '<C-\><C-n>', {
    desc = 'Exit terminal mode with jk'
}) ]]
--------------------------
--- System clipboard integration

-- paste without overwriting
vim.keymap.set('v', 'p', 'P', {
    desc = 'Paste after cursor without overwriting'
})

-- redu
vim.keymap.set('n', 'U', '<C-r>', {
    desc = 'Redo'
})

-- Copy to Clipboard
--[[ vim.keymap.set('v', '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set('v', '<leader>d', '"+d', { desc = 'Cut to system clipboard' })
vim.keymap.set('n', '<leader>y', '"+yy', { desc = 'Copy line to system clipboard' }) ]]

-- Paste from clipboard
--[[ vim.keymap.set('n', '<leader>p', '"+p', { desc = 'Paste after cursor from system clipboard' })
vim.keymap.set('n', '<leader>P', '"+P', { desc = 'Paste before cursor from system clipboard' })
vim.keymap.set('v', '<leader>p', '"+p', { desc = 'Paste after selection from system clipboard' })
vim.keymap.set('v', '<leader>P', '"+P', { desc = 'Paste before selection from system clipboard' }) ]]

-------------------------------------
--- Navigation enhancements

-- End of line movements
vim.keymap.set({'n', 'v', 'o'}, '<leader>l', '$', {
    desc = 'Move to end of line'
})
vim.api.nvim_set_keymap('', '<leader>l', '$', {
    noremap = false,
    silent = true
})

-- Beginning of line movements
vim.keymap.set({'n', 'v', 'o'}, '<leader>h', '^', {
    desc = 'Move to first non-blank character of line'
})
vim.api.nvim_set_keymap('', '<leader>h', '^', {
    noremap = false,
    silent = true
})

vim.api.nvim_set_keymap('', '<leader>m', [[:lua print(vim.api.nvim_get_mode().mode)<CR>]], {
    noremap = true,
    silent = false
})

-- Center view after search
vim.keymap.set('n', 'n', 'nzzzv', {
    desc = 'Next search result and center view'
})
vim.keymap.set('n', 'N', 'Nzzzv', {
    desc = 'Previous search result and center view'
})
--[[ vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv") ]]

-- skip folds
vim.cmd('nmap j gj', {
    desc = 'Skip folds down'
})
vim.cmd('nmap k gk', {
    desc = 'Skip folds up'
})

-- Keep window centered when going up/down
-- vim.keymap.set("n", "J", "mzJ`z")
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")

-----------------------
-- Visual --

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Move block
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {
    desc = "Move Block Down"
})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {
    desc = "Move Block Up"
})
-------------------------
--- File operations

--- Save file
vim.keymap.set('n', '<leader>w', ':w<CR>', {
    desc = 'Save file'
})

--------------------------
--- Search

-- clear search highlights
vim.keymap.set('n', '<leader><CR>', ':nohlsearch<CR>', {
    desc = 'Clear search highlights'
})

-- search ignoring case
vim.opt.ignorecase = true

-- disable "ignorecase" option if the search pattern contains upper case characters
vim.opt.smartcase = true
