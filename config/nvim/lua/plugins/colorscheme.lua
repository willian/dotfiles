return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    opts = function(_, opts)
      local flavour = os.getenv("TERM_IS_DARK") == "true" and "mocha" or "latte"
      local myopts = {
        flavour = flavour,
        transparent_background = true,
      }
      -- merge the two tables
      return vim.tbl_deep_extend("force", myopts, opts)
    end,
    -- opts = function(_, opts)
    --   local palettes = {
    --     latte = require("catppuccin.palettes").get_palette("latte"),
    --     frappe = require("catppuccin.palettes").get_palette("frappe"),
    --     macchiato = require("catppuccin.palettes").get_palette("macchiato"),
    --     mocha = require("catppuccin.palettes").get_palette("mocha"),
    --   }
    --
    --   local flavour = os.getenv("TERM_IS_DARK") == "true" and "frappe" or "latte"
    --
    --   local myopts = {
    --     flavour = flavour,
    --     transparent_background = os.getenv("TERM_IS_DARK") == "true",
    --     -- custom_highlights = function(colors)
    --     --   return {
    --     --     PackageInfoOutdatedVersion = { fg = colors.peach },
    --     --   }
    --     -- end,
    --   }
    --
    --   -- merge the two tables
    --   return vim.tbl_deep_extend("force", myopts, opts)
    -- end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
