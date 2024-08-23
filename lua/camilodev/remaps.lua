-- ajuster de ui vscode
-- manejo de la terminal, abrir nueva, abrir en la misma, cerrar, moverse entre ellas, volver al codigo.
-- apertura de la busqueda
-- scrolling correctamente
-- organizar los atajos de scrolling para que trabajen con los de vim y no con los de vscode
-- por alguna razon no me formatea los lua en pc del trabajo, en la casa si lo hace
-- terminar de poner las descripciones de los atajos
-- remapeos para redimencionar los splits directamente con vscode
-- poder usar nvim en los imputs de vscode, como el editor de symbol o el de commit message, etc...
-- para moverse en la lista de opcones de los comandos de vscode, se usa <C-n> y <C-p> pero <C-n> esta ocupado para seleccionar multiples opciones
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
-- Visual
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
vim.keymap.set({'n', 'x'}, '<C-h>', '<Cmd>call VSCodeNotify("workbench.action.focusLeftGroup")<CR>', {
    desc = 'Move to the left split'
})
vim.keymap.set({'n', 'x'}, '<C-l>', '<Cmd>call VSCodeNotify("workbench.action.focusRightGroup")<CR>', {
    desc = 'Move to the right split'
})
vim.keymap.set({'n', 'x'}, '<C-j>', '<Cmd>call VSCodeNotify("workbench.action.focusBelowGroup")<CR>', {
    desc = 'Move to the down split'
})
vim.keymap.set({'n', 'x'}, '<C-k>', '<Cmd>call VSCodeNotify("workbench.action.focusAboveGroup")<CR>', {
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

-------------------------------------
--- vim-spider keymaps, lua implementation of CamelCaseMotion

vim.keymap.set({"n", "o", "x"}, "w", "<cmd>lua require('spider').motion('w')<CR>", {
    desc = "Spider-w"
})
vim.keymap.set({"n", "o", "x"}, "e", "<cmd>lua require('spider').motion('e')<CR>", {
    desc = "Spider-e"
})
vim.keymap.set({"n", "o", "x"}, "b", "<cmd>lua require('spider').motion('b')<CR>", {
    desc = "Spider-b"
})

------------------------------------
------------------------------------
--- Remember keymaps ---

-- multicursor: <C-n>, q, Q
-- el <leader> en  vim-visual-multi es \\ y en vim-easymotion es <leader><leader>
-- vim-visual-multi <leader>A para seleccionar todas las ocurrencias

-- easymotion <leader><leader>f, <leader><leader>w, <leader><leader>b

-- modo visual block con: <C-v>
-- insertar tanto em modo visual block como en modo visual line con mi, mI, ma, mA

-- ver el listado de menus del sidebar con: <C-q>
-- cambio de nombre de una variable con: <F2>

-- mover el cursor a la anterior posicion con: <C-o> y a la siguiente con: <C-i>

-- para hacer la accion de hover es con gh o con K, para enfocar la ventana emergente y podernos mover en esta es de nuevo con K
-- para moverse en la listas de suggestions es con <C-n> y <C-p>

-- mostrar/ocultar sidebar con: <C-b>
-- previsualizar un archivo con: space
-- abrir el archivo con: l
