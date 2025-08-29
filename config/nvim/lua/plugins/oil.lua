return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      skip_confirm_for_simple_edits = true,
      win_options = {
        signcolumn = "yes:2",
      },
      view_options = {
        show_hidden = true,
      },
    },
    init = function()
      vim.keymap.set("n", "-", require("oil").toggle_float, { desc = "Open parent directory" })
    end,
  },
  {
    "refractalize/oil-git-status.nvim",
    dependencies = {
      "stevearc/oil.nvim",
    },
    config = true,
  },
}
