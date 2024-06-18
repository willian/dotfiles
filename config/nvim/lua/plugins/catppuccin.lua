return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    opts = function(_, opts)
      local palettes = {
        latte = require("catppuccin.palettes").get_palette("latte"),
        frappe = require("catppuccin.palettes").get_palette("frappe"),
        macchiato = require("catppuccin.palettes").get_palette("macchiato"),
        mocha = require("catppuccin.palettes").get_palette("mocha"),
      }

      local flavour = os.getenv("TERM_IS_DARK") == "true" and "frappe" or "latte"

      ---@class CatppuccinOptions
      local myopts = {
        flavour = flavour,
        transparent_background = os.getenv("TERM_IS_DARK") == "true",
        custom_highlights = function(colors)
          return {
            PackageInfoOutdatedVersion = { fg = colors.peach },
            CurSearch = { bg = palettes[flavour].yellow },
          }
        end,
        integrations = {
          aerial = true,
          alpha = true,
          barbecue = {
            dim_dirname = true,
            bold_basename = true,
            dim_context = false,
            alt_background = false,
          },
          cmp = true,
          dashboard = true,
          fidget = true,
          flash = true,
          gitsigns = true,
          harpoon = true,
          headlines = true,
          illuminate = true,
          indent_blankline = { enabled = true },
          leap = true,
          lsp_trouble = true,
          markdown = true,
          mason = true,
          mini = true,
          navic = { enabled = true, custom_bg = "lualine" },
          native_lsp = {
            enabled = true,
            underlines = {
              errors = { "undercurl" },
              hints = { "undercurl" },
              warnings = { "undercurl" },
              information = { "undercurl" },
            },
          },
          neotest = true,
          neotree = true,
          noice = true,
          notify = true,
          octo = true,
          semantic_tokens = true,
          symbols_outline = true,
          telescope = true,
          treesitter = true,
          treesitter_context = true,
          which_key = true,
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
