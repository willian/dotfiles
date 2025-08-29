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

-- Keeps cursor at the middle of the screen when jupping top and bottom
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Keeps cursor at the middle while searching
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Git keymaps
map("n", "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle current line blame" })
map("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Preview Hunk" })

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

--------------------
--  Command mode  --
--------------------

-- map("c", "Q", "q")
-- map("c", "Qa", "qa")
-- map("c", "W", "w")
-- map("c", "WA", "wa")
-- map("c", "WQ", "wq")
-- map("c", "wQ", "wq")
-- map("c", "WQA", "wqa")
-- map("c", "Wqa", "wqa")
-- map("c", "wQA", "wqa")
-- map("c", "WQa", "wqa")
-- map("c", "Wa", "wa")
-- map("c", "Wq", "wq")
-- map("c", "X", "x")

----------------------
--  Terminal model  --
----------------------

map("t", "<esc><esc>", [[<C-\><C-n>]], { silent = true })
