local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local output = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { output, "WarningMsg" },
      { "\nPress any key to exit...", "MoreMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- In VSCode (vscode-neovim) skip everything VSCode already provides
-- (LSP, lint/format, DAP, file explorers, pickers, git UI): keep only
-- text-editing motions (mini.surround). The official vscode extra trims
-- the rest via its allowlist.
local in_vscode = vim.g.vscode ~= nil

local spec = {
  { "LazyVim/LazyVim", import = "lazyvim.plugins" },
  -- Official VSCode auto-trim (allowlist, no colorscheme, neutered
  -- snacks, checker off). Safe to always import: returns {} outside VSCode.
  { import = "lazyvim.plugins.extras.vscode" },
}

if not in_vscode then
  vim.list_extend(spec, {
    { import = "lazyvim.plugins.extras.editor.snacks_picker" },
    { import = "lazyvim.plugins.extras.editor.harpoon2" },
    { import = "lazyvim.plugins.extras.editor.mini-files" },
    { import = "lazyvim.plugins.extras.editor.mini-diff" },
    { import = "lazyvim.plugins.extras.coding.mini-surround" },
    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "lazyvim.plugins.extras.lang.elixir" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.go" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.lang.typescript.biome" },
    { import = "lazyvim.plugins.extras.linting.eslint" },
  })
else
  -- mini.surround stays: ys/ds/cs are pure text motions, no UI.
  vim.list_extend(spec, {
    { import = "lazyvim.plugins.extras.coding.mini-surround" },
  })
end

table.insert(spec, { import = "plugins" })

require("lazy").setup({
  spec = spec,
  defaults = {
    lazy = false,
    version = false,
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
