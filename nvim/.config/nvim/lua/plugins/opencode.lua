return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  keys = {
    {
      "<leader>aa",
      function()
        require("opencode").toggle()
      end,
      desc = "Toggle OpenCode",
    },
    {
      "<leader>as",
      function()
        require("opencode").select({ submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode Select",
    },
    {
      "<leader>ai",
      function()
        require("opencode").ask("", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode Ask",
    },
    {
      "<leader>aI",
      function()
        require("opencode").ask("@this: ", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode Ask with Context",
    },
    {
      "<leader>ab",
      function()
        require("opencode").ask("@file ", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode Ask about Buffer",
    },
    {
      "<leader>ap",
      function()
        require("opencode").prompt("@this", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode Prompt",
    },
    {
      "<leader>ape",
      function()
        require("opencode").prompt("explain", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode Explain",
    },
    {
      "<leader>apf",
      function()
        require("opencode").prompt("fix", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode Fix",
    },
    {
      "<leader>apd",
      function()
        require("opencode").prompt("diagnose", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode Diagnose",
    },
    {
      "<leader>apr",
      function()
        require("opencode").prompt("review", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode Review",
    },
    {
      "<leader>apt",
      function()
        require("opencode").prompt("test", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode Test",
    },
    {
      "<leader>apo",
      function()
        require("opencode").prompt("optimize", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "OpenCode Optimize",
    },
  },
  config = function()
    vim.g.opencode_opts = {
      provider = {
        snacks = {
          win = { position = "left" },
        },
      },
    }
    vim.o.autoread = true
  end,
}
