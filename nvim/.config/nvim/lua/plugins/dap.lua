-- Load .vscode/launch.json (with comment support), as in Gentleman.
-- (.env auto-loading from Gentleman is intentionally excluded.)
return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap_vscode = require("dap.ext.vscode")
      local json = require("plenary.json")
      dap_vscode.json_decode = function(str)
        return vim.json.decode(json.json_strip_comments(str))
      end

      if vim.fn.filereadable(".vscode/launch.json") == 1 then
        dap_vscode.load_launchjs()
      end
    end,
  },
}
