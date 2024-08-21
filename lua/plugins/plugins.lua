return {{
    'vhyrro/luarocks.nvim',
    priority = 1001, -- this plugin needs to run before anything else
    opts = {
        rocks = {'magick'}
    },
    -- install vim-visual-multi plugin
    "mg979/vim-visual-multi"
    -- automatically install multi cursor plugin when using vscode
    --[[ {
      'vscode-neovim/vscode-multi-cursor.nvim',
      event = 'VeryLazy',
      cond = not not vim.g.vscode,
      opts = {},
    }, ]]
    --- automatically install flash.nvim when using vscode
    -- "folke/flash.nvim"
}}
