return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ruby_lsp = {
        mason = false,
        cmd = function(dispatchers, config)
          return vim.lsp.rpc.start(
            { vim.fn.expand("~/.local/bin/mise"), "exec", "--", "ruby-lsp" },
            dispatchers,
            { cwd = config.root_dir }
          )
        end,
      },
    },
  },
}
