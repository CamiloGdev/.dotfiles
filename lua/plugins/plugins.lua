return {{
    'vhyrro/luarocks.nvim',
    priority = 1001, -- this plugin needs to run before anything else
    opts = {
        rocks = {'magick'}
    },
    -- install vim-visual-multi plugin
    "mg979/vim-visual-multi",
    --[[ {
      "mg979/vim-visual-multi",
      init = function()
        -- vim.g.VM_default_mappings = 0
        vim.g.VM_maps = {
          ['Find Under'] = 'mc',
          ["Find Subword Under"] = "mc",
        }
        -- vim.g.VM_add_cursor_at_pos_no_mappings = 1
      end,
    } ]]
    -- install surround
    {
      "kylechui/nvim-surround",
      version = "*", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      config = function()
          require("nvim-surround").setup({
              -- Configuration here, or leave empty to use defaults
          })
      end
    },
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
