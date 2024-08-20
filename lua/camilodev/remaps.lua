local vscode = require('vscode')

-- Set space as the leader key
vim.g.mapleader = " "

--------------------------
--- System clipboard integration

-- paste without overwriting
vim.keymap.set('v', 'p', 'P', { desc = 'Paste after cursor without overwriting' })

-- redu
vim.keymap.set('n', 'U', '<C-r>', { desc = 'Redo' })

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
vim.keymap.set({'n', 'v', 'o', 'x'}, '<leader>l', '$', { desc = 'Move to end of line' })

-- Beginning of line movements
vim.keymap.set({'n', 'v', 'o', 'x'}, '<leader>h', '^', { desc = 'Move to first non-blank character of line' })

-- Center view after search
vim.keymap.set('n', 'N', 'Nzz', { desc = 'Previous search result and center view' })
vim.keymap.set('n', 'n', 'nzz', { desc = 'Next search result and center view' })
--[[ vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv") ]]

-- skip folds
vim.cmd('nmap j gj', { desc = 'Skip folds down' })
vim.cmd('nmap k gk', { desc = 'Skip folds up' })

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
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Block Down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Block Up" })
-------------------------
--- File operations

--- Save file
vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save file' })

--------------------------
--- Search

-- clear search highlights
vim.keymap.set('n', '<leader><CR>', ':nohlsearch<CR>', { desc = 'Clear search highlights' })

-- search ignoring case
vim.opt.ignorecase = true

-- disable "ignorecase" option if the search pattern contains upper case characters
vim.opt.smartcase = true

----------------------
---Multiple cursors
-- local cursors = require('vscode-multi-cursor')

--[[ vim.api.nvim_set_hl(0, 'VSCodeCursor', {
    bg = '#542fa4',
    fg = 'white',
    default = true
})

vim.api.nvim_set_hl(0, 'VSCodeCursorRange', {
    bg = '#542fa4',
    fg = 'white',
    default = true
})

vim.keymap.set({ "n", "x", "i" }, "<C-m>", function()
  cursors.addSelectionToNextFindMatch()
end)

vim.keymap.set({ "n", "x", "i" }, "<CS-m>", function()
  cursors.addSelectionToPreviousFindMatch()
end)

vim.keymap.set({ "n", "x", "i" }, "<CS-l>", function()
  cursors.selectHighlights()
end)

-- flash
vim.api.nvim_set_hl(0, 'FlashLabel', {
    bg = '#e11684',
    fg = 'white'
})

vim.api.nvim_set_hl(0, 'FlashMatch', {
    bg = '#7c634c',
    fg = 'white'
})

vim.api.nvim_set_hl(0, 'FlashCurrent', {
    bg = '#7c634c',
    fg = 'white'
}) ]]
