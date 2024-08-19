-- init file for the nvim configuration

-- Set space as the leader key
vim.g.mapleader = " "


-- System clipboard integration

-- Copy to clipboard
vim.keymap.set('v', '<leader>y', '"+y', { desc = 'Copy to system clipboard' })
vim.keymap.set('v', '<leader>d', '"+d', { desc = 'Cut to system clipboard' })
vim.keymap.set('n', '<leader>y', '"+yy', { desc = 'Copy line to system clipboard' })

-- Paste from clipboard
vim.keymap.set('n', '<leader>p', '"+p', { desc = 'Paste after cursor from system clipboard' })
vim.keymap.set('n', '<leader>P', '"+P', { desc = 'Paste before cursor from system clipboard' })
vim.keymap.set('v', '<leader>p', '"+p', { desc = 'Paste after selection from system clipboard' })
vim.keymap.set('v', '<leader>P', '"+P', { desc = 'Paste before selection from system clipboard' })

-- Navigation enhancements

-- End of line movements
vim.keymap.set({'n', 'v', 'o'}, '<leader>l', '$', { desc = 'Move to end of line' })

-- Beginning of line movements
vim.keymap.set({'n', 'v', 'o'}, '<leader>h', '^', { desc = 'Move to first non-blank character of line' })

-- Center view after search
vim.keymap.set('n', 'N', 'Nzz', { desc = 'Previous search result and center view' })
vim.keymap.set('n', 'n', 'nzz', { desc = 'Next search result and center view' })

