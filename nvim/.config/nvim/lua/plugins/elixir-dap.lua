return {
  {
    "mfussenegger/nvim-dap",
    init = function()
      local configured = false

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "elixir", "eelixir" },
        callback = function()
          if configured then
            return
          end

          configured = true
          local dap = require("dap")
          dap.adapters.mix_task = {
            type = "executable",
            command = vim.fn.stdpath("data") .. "/mason/packages/elixir-ls/debug_adapter.sh",
          }
          dap.configurations.elixir = {
            {
              type = "mix_task",
              request = "launch",
              name = "Mix test",
              task = "test",
              taskArgs = { "--trace" },
              startApps = true,
              projectDir = "${workspaceFolder}",
              requireFiles = { "test/**/test_helper.exs", "test/**/*_test.exs" },
            },
            {
              type = "mix_task",
              request = "launch",
              name = "Mix run",
              task = "run",
              projectDir = "${workspaceFolder}",
            },
          }
        end,
      })
    end,
  },
}
