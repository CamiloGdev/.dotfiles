-- ajuster de ui vscode
-- manejo de la terminal, abrir nueva, abrir en la misma, cerrar, moverse entre ellas, volver al codigo.
-- apertura de la busqueda
-- scrolling correctamente
-- mostrar, ocultar el sidebar
-- ir al explorador de archivos, volver al codigo
-- mostrar el archivo sin salir del explorador y ocultar al moverse, o mostrar el otro al que nos movimos
-- abrir el archivo sin salir del explorador
-- abrir el archivo e ir a el directamente
-- buscar como hacer el rename de una declaracion apra que cambie en todo el codigo
-- por alguna razon no me formatea los lua en pc del trabajo, en la casa si lo hace
-- terminar de poner las descripciones de los atajos
-- navegacion entre tabs directamente en los atajos de vscode: con tabulacion
-- moverse entre los splits directamente con los atajos de vscode: ctrl y direcciones
-- remapeos para redimencionar, y interactuar con los splits directamente con vscode
-- organizar los atajos de scrolling para que trabajen con los de vim y no con los de vscode
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

-- Center view after search
vim.keymap.set('n', 'n', 'nzzzv', {
    desc = 'Next search result and center view'
})
vim.keymap.set('n', 'N', 'Nzzzv', {
    desc = 'Previous search result and center view'
})
--[[ vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz") ]]

-- Keep window centered when going up/down
-- vim.keymap.set("n", "J", "mzJ`z")
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")

---------------------------------
--- Fold and unfold
vim.keymap.set({'n', 'x'}, 'zc', '<Cmd>lua require("vscode").call("editor.toggleFold")<CR>', {
    desc = 'Fold current block'
})
vim.keymap.set({'n', 'x'}, 'zC', '<Cmd>lua require("vscode").call("editor.foldAll")<CR>', {
    desc = 'Unfold all blocks'
})
vim.keymap.set({'n', 'x'}, 'zo', '<Cmd>lua require("vscode").call("editor.unfold")<CR>', {
    desc = 'Unfold current block'
})
vim.keymap.set({'n', 'x'}, 'zO', '<Cmd>lua require("vscode").call("editor.unfoldAll")<CR>', {
    desc = 'Unfold all blocks'
})

-- skip folds
vim.cmd('nmap j gj', {
    desc = 'Skip folds down'
})
vim.cmd('nmap k gk', {
    desc = 'Skip folds up'
})

-----------------------
-- Visual --

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Move block
vim.keymap.set("v", "J", "<Cmd>m '>+1<CR>gv=gv", {
    desc = "Move Block Down"
})
vim.keymap.set("v", "K", "<Cmd>m '<-2<CR>gv=gv", {
    desc = "Move Block Up"
})
-------------------------
--- File operations

--- Save file
vim.keymap.set({'n', 'x'}, '<leader>w', '<Cmd>w<CR>', {
    desc = 'Save file'
})

-- Clouse file
vim.keymap.set({'n', 'x'}, '<leader><leader>q', '<Cmd>Quit<CR>', {
    silent = true,
    noremap = true
})

-- Clouse all files
vim.keymap.set({'n', 'x'}, '<leader><leader>Q', '<Cmd>Qall<CR>', {
    silent = true,
    noremap = true
})

------------------------------
--- Tab navigation
vim.keymap.set({'n', 'x'}, '<Tab>', '<Cmd>Tabnext<CR>', {
    desc = 'Next tab'
})
vim.keymap.set({'n', 'x'}, '<S-Tab>', '<Cmd>Tabprevious<CR>', {
    desc = 'Previous tab'
})
------------------------------
--- Splits
-- Create splits
vim.keymap.set({'n', 'x'}, '<leader>v', '<Cmd>Vsplit<CR>', {
    desc = 'Vertical split'
})
vim.keymap.set({'n', 'x'}, '<leader>s', '<Cmd>Split<CR>', {
    desc = 'Horizontal split'
})

-- Move between splits
vim.keymap.set({'n', 'x'}, '<C-h>', '<Cmd>call VSCodeNotify("workbench.action.navigateLeft")<CR>', {
    desc = 'Move to the left split'
})
vim.keymap.set({'n', 'x'}, '<C-l>', '<Cmd>call VSCodeNotify("workbench.action.navigateRight")<CR>', {
    desc = 'Move to the right split'
})
vim.keymap.set({'n', 'x'}, '<C-j>', '<Cmd>call VSCodeNotify("workbench.action.navigateDown")<CR>', {
    desc = 'Move to the down split'
})
vim.keymap.set({'n', 'x'}, '<C-k>', '<Cmd>call VSCodeNotify("workbench.action.navigateUp")<CR>', {
    desc = 'Move to the up split'
})

--------------------------
--- Search

-- clear search highlights
vim.keymap.set('n', '<leader><CR>', '<Cmd>nohlsearch<CR>', {
    desc = 'Clear search highlights'
})

-- search ignoring case
vim.opt.ignorecase = true

-- disable "ignorecase" option if the search pattern contains upper case characters
vim.opt.smartcase = true

--- Remember keymaps
-- el <leader> en  vim-visual-multi es \\ y en vim-easymotion es <leader><leader>
-- vim-visual-multi <leader>A para seleccionar todas las ocurrencias
-- easymotion <leader><leader>f, <leader><leader>w, <leader><leader>b
-- multicursor <C-n>, q, Q
-- recordar el modo visual block con <C-v>
-- insertar tanto em modo visual block como en modo visual line con mi, mI, ma, mA
