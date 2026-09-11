return {
  "vim-test/vim-test",
  dependencies = {
    "preservim/vimux",
    "willian/vim-test-herdr",
  },
  keys = {
    { "<leader>tT", "<CMD>TestSuite<CR>", desc = "Run test suite of the current file" },
    { "<leader>tg", "<CMD>TestVisit<CR>", desc = "Open the last run test in the current buffer" },
    { "<leader>tl", "<CMD>TestLast<CR>", desc = "Run the last test" },
    { "<leader>tr", "<CMD>TestNearest<CR>", desc = "Run a test nearest to the cursor" },
    { "<leader>tt", "<CMD>TestFile<CR>", desc = "Run tests for the current file" },
    {
      "<leader>tc",
      function()
        vim.cmd(vim.env.HERDR_ENV == "1" and "HerdrCloseRunner" or "VimuxCloseRunner")
      end,
      desc = "Close test runner pane",
    },
  },
  config = function()
    vim.g["test#preserve_screen"] = 0
    vim.g.VimuxOrientation = "v"
    vim.g.VimuxRunnerName = "VimuxRunner"
    vim.g.VimuxCloseOnExit = 1

    vim.g["test#strategy"] = vim.env.HERDR_ENV == "1" and "herdr" or "vimux"

    local subdirs = { "backend", "frontend" }

    -- Cache escaped patterns at config time for performance
    local patterns = vim.tbl_map(function(subdir)
      return vim.pesc(subdir .. "/")
    end, subdirs)

    vim.g["test#custom_transformations"] = {
      subdirectory = function(cmd)
        local filepath = vim.fn.expand("%:p")
        local cwd = vim.fn.getcwd()

        for i, subdir in ipairs(subdirs) do
          if vim.startswith(filepath, cwd .. "/" .. subdir .. "/") then
            local subdir_path = vim.fn.shellescape(cwd .. "/" .. subdir)
            return ("cd %s &&\n%s"):format(subdir_path, cmd:gsub(patterns[i], "", 1))
          end
        end

        return cmd
      end,
    }
    vim.g["test#transformation"] = "subdirectory"
  end,
}
