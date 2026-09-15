-- mini.surround with tpope/vim-surround-style keys (author's official recipe).
return {
  {
    "nvim-mini/mini.surround",
    -- Survive the vscode trim: pure text motions, no UI.
    vscode = true,
    opts = {
      mappings = {
        add = "ys",
        delete = "ds",
        find = "",
        find_left = "",
        highlight = "",
        replace = "cs",
        suffix_last = "",
        suffix_next = "",
      },
      search_method = "cover_or_next",
    },
  },
}
