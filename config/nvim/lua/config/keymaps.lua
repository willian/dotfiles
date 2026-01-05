-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua

local map = vim.keymap.set

-------------------
--  Normal mode  --
-------------------

-- Split window
map("n", "ss", ":split<CR>", { desc = "Split window horizontally" })
map("n", "sv", ":vsplit<CR>", { desc = "Split window vertically" })
map("n", "se", "<C-w>=", { desc = "Make splits equal size" })
map("n", "sx", ":close<CR>", { desc = "Close current split" })
map("n", "sq", ":close<CR>", { desc = "Close current split" })

-- Keeps cursor at the middle while searching
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- overwrite lazyvim mappings with vim-tmux-navigator mappings
-- see: https://github.com/christoomey/vim-tmux-navigator/blob/master/plugin/tmux_navigator.vim
map("n", "<C-h>", ":<C-U>TmuxNavigateLeft<CR>", { silent = true })
map("n", "<C-j>", ":<C-U>TmuxNavigateDown<CR>", { silent = true })
map("n", "<C-k>", ":<C-U>TmuxNavigateUp<CR>", { silent = true })
map("n", "<C-l>", ":<C-U>TmuxNavigateRight<CR>", { silent = true })
map("n", "<C-\\>", ":<C-U>TmuxNavigatePrevious<CR>", { silent = true })

-- Easier way to delete current buffer
map("n", "<S-q>", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })

-------------------
--  Visual mode  --
-------------------

-- move selected lines
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move up" })

----------------------
--  Terminal model  --
----------------------

map("t", "<esc>", [[<C-\><C-n>]], { silent = true })
map("t", "jk", [[<C-\><C-n>]], { silent = true })
