return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.inlay_hints = { enabled = false }
      opts.servers = opts.servers or {}
      opts.servers.angularls = {
        root_dir = function(fname)
          return require("lspconfig.util").root_pattern("angular.json", "project.json")(fname)
        end,
      }
      -- The lang.elixir extra defines its own keys for elixirls, which
      -- drops the default (+snacks) key set every other server gets.
      -- Restore it here so goto/navigation works in Elixir too.
      local elixir = opts.servers.elixirls or {}
      local star_keys = opts.servers["*"] and opts.servers["*"].keys or {}
      elixir.keys = vim.list_extend(vim.deepcopy(star_keys), elixir.keys or {})
      opts.servers.elixirls = elixir
    end,
  },
}
