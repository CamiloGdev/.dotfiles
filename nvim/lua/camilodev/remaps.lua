-- copilot CLI en la terminal
-- manejo de la terminal,  cerrar, moverse entre ellas, volver al codigo.sin cerrar  o minimizar
-- apertura de la busqueda
-- por alguna razon no me formatea los lua en pc del trabajo, en la casa si lo hace
-- poder usar nvim en los imputs de vscode, como el editor de symbol o el de commit message, etc...
-- por alguna razon el centrado con zz despues de <C-d> y <C-u> no funciona en vscode
-- el scroll por lineas en vscode no desplaza el cursor, lo deja en el mismo lugar y solo mueve la pantalla
-- optimización de windows
-----------------------------
-- For executing commands, try to use in this order of priority: <Cmd>, :, vim.cmd; in terms of performance
-- Check to determine if we are in VSCode
local in_vscode = vim.g.vscode ~= nil

-- Load the VSCode module only if we are in VSCode
local vscode = in_vscode and require('vscode') or nil

-- Simplified function to handle any action in both VSCode and Neovim
local function create_action(vscode_action, nvim_action)
    if in_vscode then
        return vscode_action
    else
        return nvim_action
    end
end

-- Set space as the leader key
vim.g.mapleader = " "

-----------------------------
-- Open Netrw directory listing
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

-------------------------------
-- Exit insert mode with jk

vim.keymap.set('i', 'jk', '<Esc>', {
    desc = 'Exit insert mode with jk'
})

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

-------------------------------------
--- Navigation enhancements

-- End of line movements
vim.keymap.set({'n', 'v', 'o'}, '<leader>l', '$', {
    desc = 'Move to end of line'
})

-- Beginning of line movements
vim.keymap.set({'n', 'v', 'o'}, '<leader>h', '^', {
    desc = 'Move to first non-blank character of line'
})

-- Center view after search
vim.keymap.set('n', 'n', 'nzzzv', {
    desc = 'Next search result and center view'
})
vim.keymap.set('n', 'N', 'Nzzzv', {
    desc = 'Previous search result and center view'
})

-- Keep window centered when going up/down
vim.keymap.set("n", "J", "mzJ`z", {
    desc = "Join lines and maintain cursor position"
})
vim.keymap.set({"n", "x"}, "<C-d>", "<C-d>zz", {
    desc = "Scroll down and keep cursor centered"
})
vim.keymap.set({"n", "x"}, "<C-u>", "<C-u>zz", {
    desc = "Scroll up and keep cursor centered"
})

---------------------------------
--- Fold and unfold
if in_vscode then
    vim.keymap.set({'n', 'x'}, 'zc', '<Cmd>lua require("vscode").call("editor.toggleFold")<CR>', {
        desc = 'Toggle fold current block'
    })
    vim.keymap.set({'n', 'x'}, 'zC', '<Cmd>lua require("vscode").call("editor.foldAll")<CR>', {
        desc = 'Fold all blocks'
    })
    vim.keymap.set({'n', 'x'}, 'zo', '<Cmd>lua require("vscode").call("editor.unfold")<CR>', {
        desc = 'Unfold current block'
    })
    vim.keymap.set({'n', 'x'}, 'zO', '<Cmd>lua require("vscode").call("editor.unfoldAll")<CR>', {
        desc = 'Unfold all blocks'
    })
end

-- skip folds
if in_vscode then
    vim.cmd('nmap j gj', {
        desc = 'Skip folds down'
    })
    vim.cmd('nmap k gk', {
        desc = 'Skip folds up'
    })
end

-----------------------
-- Visual
-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", {
    desc = "Indent left and stay in visual mode"
})
vim.keymap.set("v", ">", ">gv", {
    desc = "Indent right and stay in visual mode"
})

-- Move block
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {
    desc = "Move Block Down",
    silent = true
})
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {
    desc = "Move Block Up",
    silent = true
})

-------------------------
--- File operations

--- Save file
vim.keymap.set({'n', 'x'}, '<leader>w', '<Cmd>w<CR>', {
    desc = 'Save current file'
})

-- Clouse current file
vim.keymap.set({'n', 'x'}, '<leader><leader>q', create_action('<Cmd>Quit<CR>', '<Cmd>q<CR>'), {
    desc = 'Close current file'
})

-- Close all files
vim.keymap.set({'n', 'x'}, '<leader><leader>Q', create_action('<Cmd>Qall<CR>', '<Cmd>qa<CR>'), {
    desc = 'Close all files'
})

------------------------------
--- Tab navigation
if in_vscode then
    vim.keymap.set({'n', 'x'}, '<Tab>', '<Cmd>Tabnext<CR>', {
        desc = 'Next tab'
    })
    vim.keymap.set({'n', 'x'}, '<S-Tab>', '<Cmd>Tabprevious<CR>', {
        desc = 'Previous tab'
    })
end

------------------------------
--- Splits
-- Create splits
if in_vscode then
    vim.keymap.set({'n', 'x'}, '<leader>v', '<Cmd>Vsplit<CR>', {
        desc = 'Vertical split'
    })
    vim.keymap.set({'n', 'x'}, '<leader>s', '<Cmd>Split<CR>', {
        desc = 'Horizontal split'
    })
end

-- Move between splits
if in_vscode then
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
end

-----------------------
-- vscode copilot keymaps
--
if in_vscode then
    vim.keymap.set({'n', 'x'}, '<leader><C-i>', '<Cmd>call VSCodeNotify("inlineChat.start")<CR>', {
        desc = 'Move to the left split'
    })
end

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
    desc = "Spider-w, move to the next word start"
})
vim.keymap.set({"n", "o", "x"}, "e", "<cmd>lua require('spider').motion('e')<CR>", {
    desc = "Spider-e, move to the end of the word"
})
vim.keymap.set({"n", "o", "x"}, "b", "<cmd>lua require('spider').motion('b')<CR>", {
    desc = "Spider-b, move to the previous word start"
})

------------------------------------
------------------------------------
--- Remember keymaps ---

-- multicursor: <C-m>, q, Q
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

-- scrioll por lineas con: <C-e> y <C-y>
-- scroll por pantalla con: <C-d> y <C-u>

-- abrir el modal de copilot con: <C-i> en insert mode
