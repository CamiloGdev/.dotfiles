return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    -- In VSCode be forgiving with leader sequences (LazyVim default);
    -- in the terminal keep it snappy.
    vim.o.timeoutlen = vim.g.vscode and 1000 or 300
  end,
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
    { "<leader>o", group = "Obsidian" },
  },
}
