return {
  "vim-test/vim-test",
  dependencies = { "preservim/vimux" },
  keys = {
    { "<leader>tT", "<CMD>TestSuite<CR>", desc = "Run test suite of the current file" },
    { "<leader>tg", "<CMD>TestVisit<CR>", desc = "Open the last run test in the current buffer" },
    { "<leader>tl", "<CMD>TestLast<CR>", desc = "Run the last test" },
    { "<leader>tr", "<CMD>TestNearest<CR>", desc = "Run a test nearest to the cursor" },
    { "<leader>tt", "<CMD>TestFile<CR>", desc = "Run tests for the current file" },
    { "<leader>vq", "<CMD>VimuxCloseRunner<CR>", desc = "Close vim tmux runner pane" },
  },
  config = function()
    vim.cmd('let test#strategy = "vimux"')
    vim.cmd("let g:test#preserve_screen = 0")
    vim.cmd('let g:VimuxOrientation = "v"')
    vim.cmd("let g:VimuxCloseOnExit = 1")
    vim.cmd("let g:VimuxCommandShell = 1")
  end,
}
