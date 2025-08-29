return {
  "vim-test/vim-test",
  dependencies = { "preservim/vimux" },
  keys = {
    { "<leader>t", "", desc = "+test" },
    { "<leader>tt", "<CMD>TestFile<CR>", desc = "Run tests for the current file" },
    { "<leader>tT", "<CMD>TestSuite<CR>", desc = "Run test suite of the current file" },
    { "<leader>tr", "<CMD>TestNearest<CR>", desc = "Run a test nearest to the cursor" },
    { "<leader>tl", "<CMD>TestLast<CR>", desc = "Run the last test" },
    { "<leader>tg", "<CMD>TestVisit<CR>", desc = "Open the last run test in the current buffer" },
  },
  config = function()
    vim.cmd('let g:VimuxOrientation = "v"')
    vim.cmd('let test#strategy = "vimux"')
  end,
}
