return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    opts = function(_, opts)
      local flavour = os.getenv("TERM_IS_DARK") == "true" and "mocha" or "latte"
      local myopts = {
        auto_integrations = true,
        flavour = flavour,
        transparent_background = true,
        float = {
          transparent = false,
          solid = false,
        },
      }
      -- merge the two tables
      return vim.tbl_deep_extend("force", myopts, opts)
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
