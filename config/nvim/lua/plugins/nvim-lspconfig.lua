-- Uncomment the following lines to enable logging
-- vim.lsp.set_log_level("debug")
-- if vim.fn.has("nvim-0.5.1") == 1 then
--   require("vim.lsp.log").set_format_func(vim.inspect)
-- end

return {
  "neovim/nvim-lspconfig",
  opts = {
    diagnostics = {
      float = {
        border = "rounded",
      },
    },
    -- servers = {
    --   ruby_lsp = {
    --     cmd = { os.getenv("HOME") .. "/.local/share/mise/shims/ruby-lsp" },
    --   },
    -- },
  },
}
