return {{
    'vhyrro/luarocks.nvim',
    priority = 1001, -- this plugin needs to run before anything else
    opts = {
        rocks = {'magick'}
    },
    -- install vim-visual-multi plugin
    {"mg979/vim-visual-multi"},
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
    -- install easymotion
    {"easymotion/vim-easymotion"}
}}
