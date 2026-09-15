-- LazyVim loads this file on its VeryLazy event.
-- Add personal keymaps here as they are approved.
--
-- RULE: avoid <leader><leader> (double-tap Space) for shortcuts used in
-- VSCode. The vscode-neovim transport merges rapid identical Spaces, so
-- double-leader sequences intermittently arrive as single-leader + key
-- (upstream vscode-neovim#1137, unresolved). If a double-leader map is
-- ever added for VSCode use, it must be retry-safe and side-effect free;
-- critical get single-leader keys instead. Terminal-only
-- double-leader maps are fine (double-tap is reliable there).

-- True when running embedded in VSCode (vscode-neovim).
local in_vscode = vim.g.vscode ~= nil

if in_vscode then
  -- Bare Space must do nothing: without this, a lost second key in a
  -- leader sequence silently moves the cursor (vanilla Space = `l`)
  -- and everything after executes in the wrong place.
  vim.keymap.set({ "n", "x", "o" }, "<space>", "<nop>", { desc = "Leader prefix only" })
  -- Remove LazyVim's <leader><space> (find files, dead with the picker off):
  -- it exact-matches mid double-leader sequence and hijacks it.
  pcall(vim.keymap.del, "n", "<leader><space>")
end

local function selected_text()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])

  if #lines == 0 then
    return
  end

  if #lines == 1 then
    lines[1] = lines[1]:sub(start_pos[3], end_pos[3])
  else
    lines[1] = lines[1]:sub(start_pos[3])
    lines[#lines] = lines[#lines]:sub(1, end_pos[3])
  end

  return vim.fn.escape(table.concat(lines, "\n"), "\\.*[]^$()+?{}")
end

-- ---------------------------------------------------------------------------
-- 1. Insert-mode editing: escape and word deletion without leaving insert.
-- ---------------------------------------------------------------------------
vim.keymap.set({ "i", "n", "x" }, "<c-c>", "<c-\\><c-n>", { desc = "Escape" })

vim.keymap.set("i", "jk", "<esc>", { desc = "Exit insert mode" })

-- Delete to end of word without leaving insert mode (as in Gentleman).
-- Overrides Blink's <C-b> scroll_documentation_up, same tradeoff as Gentleman.
vim.keymap.set("i", "<c-b>", "<c-o>de", { desc = "Delete to end of word" })

-- ---------------------------------------------------------------------------
-- 2. Motion: beginning/end of line (from previous config, modes n/v/o).
-- Displaced Lazy and Harpoon menu move below (section 7).
-- ---------------------------------------------------------------------------
vim.keymap.set({ "n", "v", "o" }, "<leader>l", "$", { desc = "Move to end of line" })
vim.keymap.set({ "n", "v", "o" }, "<leader>h", "^", { desc = "Move to first non-blank character" })

-- ---------------------------------------------------------------------------
-- 3. Visual editing: swap paste so p preserves the register (acts as P),
-- P keeps the default replace-into-register behavior.
-- ---------------------------------------------------------------------------
vim.keymap.set("v", "p", "P", { desc = "Paste without overwriting register" })
vim.keymap.set("v", "P", "p", { desc = "Paste replacing register" })

-- ---------------------------------------------------------------------------
-- 4. Safety blocks (as in Gentleman): neutralize accident-prone keys.
-- ---------------------------------------------------------------------------
for _, mode in ipairs({ "i", "n", "x" }) do
  vim.keymap.set(mode, "<a-j>", "<nop>")
  vim.keymap.set(mode, "<a-k>", "<nop>")
end

vim.keymap.set("x", "J", "<nop>")
vim.keymap.set("x", "K", "<nop>")

-- ---------------------------------------------------------------------------
-- 5. Files: save and close.
-- Save lives on double-leader (terminal only; VSCode uses Cmd+S) so
-- single <leader>w stays a pure window prefix (section 6).
-- Close avoids double-tap: single-leader Q closes all (Shift = accident
-- protection); close-file is double-q in the terminal, Cmd+W in VSCode.
-- ---------------------------------------------------------------------------
vim.keymap.set({ "n", "x", "i" }, "<c-s>", function()
  if vim.fn.expand("%:t") == "" then
    vim.notify("No file to save", vim.log.levels.WARN)
    return
  end

  vim.cmd.write()
  vim.notify(vim.fn.expand("%:t") .. " saved")
end, { desc = "Save File" })

if not in_vscode then
  vim.keymap.set({ "n", "x" }, "<leader><leader>w", "<cmd>w<cr>", { desc = "Save current file" })
  -- Cmd+S saves in terminal Ghostty (must arrive via Kitty protocol;
  -- verify live: if it types instead, the terminal ate it).
  vim.keymap.set({ "n", "x", "i" }, "<D-s>", "<cmd>w<cr>", { desc = "Save current file" })
end

if in_vscode then
  vim.keymap.set({ "n", "x" }, "<leader>Q", function()
    require("vscode").call("workbench.action.closeAllEditors")
  end, { desc = "Close all files" })
else
  vim.keymap.set({ "n", "x" }, "<leader>Q", "<cmd>qa<cr>", { desc = "Close all files" })
end
-- Double-leader close aliases live only in the terminal: in VSCode
-- closing is Cmd+W (file) and <leader>Q (all).
if not in_vscode then
  vim.keymap.set({ "n", "x" }, "<leader><leader>q", "<cmd>q<cr>", { desc = "Close current file" })
  vim.keymap.set({ "n", "x" }, "<leader><leader>Q", "<cmd>qa<cr>", { desc = "Close all files" })
end

-- ---------------------------------------------------------------------------
-- 6. Windows and splits (homogeneous in both environments).
-- ---------------------------------------------------------------------------
if in_vscode then
  vim.keymap.set({ "n", "x" }, "<leader>wv", function()
    require("vscode").call("workbench.action.splitEditorRight")
  end, { desc = "Split editor right" })
  vim.keymap.set({ "n", "x" }, "<leader>ws", function()
    require("vscode").call("workbench.action.splitEditorDown")
  end, { desc = "Split editor down" })
else
  vim.keymap.set({ "n", "x" }, "<leader>wv", "<cmd>vsplit<cr>", { desc = "Split window vertically" })
  vim.keymap.set({ "n", "x" }, "<leader>ws", "<cmd>split<cr>", { desc = "Split window horizontally" })
end

-- ---------------------------------------------------------------------------
-- 7. Buffers, plugin managers and pickers.
-- Lazy and Harpoon menu avoid double-tap (VSCode transport merges rapid
-- Spaces). Frequent actions get easy keys, rare ones keep aliases.
-- ---------------------------------------------------------------------------
vim.keymap.set("n", "<leader>bq", '<esc>:%bdelete|edit #|normal`"<cr>', { desc = "Delete Other Buffers" })

if in_vscode then
  -- Snacks.bufdelete / :bdelete destroy the hidden buffers vscode-neovim
  -- syncs with, freezing vim motions (your log). Route to VSCode actions.
  vim.keymap.set("n", "<leader>bd", function()
    require("vscode").call("workbench.action.closeActiveEditor")
  end, { desc = "Close editor" })
  vim.keymap.set("n", "<leader>bo", function()
    require("vscode").call("workbench.action.closeOtherEditors")
  end, { desc = "Close other editors" })
  vim.keymap.set("n", "<leader>bq", function()
    require("vscode").call("workbench.action.closeOtherEditors")
  end, { desc = "Close other editors" })
end

vim.keymap.set("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })
if not in_vscode then
  -- Changelog only matters where plugins are managed (terminal).
  vim.keymap.set("n", "<leader><leader>l", function()
    ---@diagnostic disable-next-line: undefined-global -- LazyVim global exists at runtime (lazydev knows it); plain lua_ls doesn't.
    LazyVim.news.changelog()
  end, { desc = "LazyVim Changelog" })
end
if not in_vscode then
  -- Harpoon doesn't exist in VSCode: double-h lives only in the terminal,
  -- where double-tap is reliable.
  vim.keymap.set("n", "<leader><leader>h", function()
    local harpoon = require("harpoon")
    harpoon.ui:toggle_quick_menu(harpoon:list())
  end, { desc = "Harpoon Quick Menu" })
end
if not in_vscode then
  -- Base maps <leader>- to split-below, shadowing Oil-in-current-dir.
  -- Splits go through <leader>ws, so free it for Oil.
  pcall(vim.keymap.del, "n", "<leader>-")
  vim.keymap.set("n", "<leader>-", function()
    local oil = require("oil")
    local current_file = vim.api.nvim_buf_get_name(0)

    if current_file ~= "" then
      oil.open(vim.fn.fnamemodify(current_file, ":h"))
    else
      oil.open()
    end
  end, { desc = "Open Oil in current file's directory" })
end

if not in_vscode then
  -- Screenkey and Obsidian plugins don't load in VSCode; their commands
  -- would only error there.
  vim.keymap.set("n", "<leader>uk", "<cmd>Screenkey<cr>", { desc = "Toggle Screenkey" })
  vim.keymap.set("n", "<leader>oc", "<cmd>Obsidian check<cr>", { desc = "Obsidian Check" })
  vim.keymap.set("n", "<leader>ot", "<cmd>Obsidian template<cr>", { desc = "Obsidian Template" })
  vim.keymap.set("n", "<leader>oo", "<cmd>Obsidian open<cr>", { desc = "Open in Obsidian" })
  vim.keymap.set("n", "<leader>ob", "<cmd>Obsidian backlinks<cr>", { desc = "Obsidian Backlinks" })
  vim.keymap.set("n", "<leader>ol", "<cmd>Obsidian links<cr>", { desc = "Obsidian Links" })
  vim.keymap.set("n", "<leader>on", "<cmd>Obsidian new<cr>", { desc = "New Obsidian Note" })
  vim.keymap.set("n", "<leader>os", "<cmd>Obsidian search<cr>", { desc = "Search Obsidian" })
  vim.keymap.set("n", "<leader>oq", "<cmd>Obsidian quick_switch<cr>", { desc = "Obsidian Quick Switch" })
end

-- Grep selection needs Snacks picker (off in VSCode: use Cmd+Shift+F there).
if not in_vscode then
  vim.keymap.set("x", "<leader>sg", function()
    local search = selected_text()
    if search then
      Snacks.picker.grep({ search = search })
    end
  end, { desc = "Grep Selection" })

  vim.keymap.set("x", "<leader>sG", function()
    local search = selected_text()
    if search then
      Snacks.picker.grep({ search = search, cwd = LazyVim.root.git() })
    end
  end, { desc = "Grep Selection (Root)" })
end

vim.keymap.set("n", "<leader>md", function()
  vim.cmd("delmarks!")
  vim.cmd("delmarks A-Z0-9")
  vim.notify("All marks deleted")
end, { desc = "Delete All Marks" })

-- ---------------------------------------------------------------------------
-- 8. VSCode-only: folds via its API (the embedded Neovim folds an
-- invisible buffer). In the terminal folds stay vanilla.
-- S-h/S-l (previous/next editor) come from the official vscode extra.
-- ---------------------------------------------------------------------------
if in_vscode then
  vim.keymap.set({ "n", "x" }, "zc", function()
    require("vscode").call("editor.fold")
  end, { desc = "Fold" })
  vim.keymap.set({ "n", "x" }, "zC", function()
    require("vscode").call("editor.foldRecursively")
  end, { desc = "Fold recursively" })
  vim.keymap.set({ "n", "x" }, "zo", function()
    require("vscode").call("editor.unfold")
  end, { desc = "Unfold" })
  vim.keymap.set({ "n", "x" }, "zO", function()
    require("vscode").call("editor.unfoldRecursively")
  end, { desc = "Unfold recursively" })
end
