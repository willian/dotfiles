return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      rubocop = {
        cmd = { "bundle", "exec", "rubocop", "--lsp" },
        root_dir = function(fname)
          local util = require("lspconfig.util")
          -- Look for Gemfile to find the root directory
          return util.root_pattern("Gemfile")(fname)
        end,
      },
    },
  },
}
