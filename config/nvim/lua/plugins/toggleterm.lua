return {
  "akinsho/toggleterm.nvim",
  version = "*",
  lazy = false,
  keys = {
    { "<leader>T1", "<cmd>1ToggleTerm<CR>", desc = "Toggle terminal #1" },
    { "<leader>T2", "<cmd>2ToggleTerm<CR>", desc = "Toggle terminal #2" },
    { "<leader>T3", "<cmd>3ToggleTerm<CR>", desc = "Toggle terminal #3" },
    { "<leader>T4", "<cmd>4ToggleTerm<CR>", desc = "Toggle terminal #4" },
  },
  opts = {
    open_mapping = [[\\]],
    direction = "float",
    float_opts = {
      border = "rounded",
    },
  },
}
