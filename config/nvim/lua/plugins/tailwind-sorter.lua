return {
  "laytan/tailwind-sorter.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
  },
  build = "cd formatter && npm ci && npm run build",
  keys = {
    { "<leader>cts", "<cmd>TailwindSort<CR>", desc = "Sort tailwind classes" },
  },
  config = true,
}
