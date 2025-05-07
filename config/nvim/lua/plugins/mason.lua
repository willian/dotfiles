return {
  {
    "williamboman/mason.nvim",
    -- TODO: Remove this when Lazyvim fixes this issue:
    -- https://github.com/LazyVim/LazyVim/issues/6039
    version = "^1.0.0",
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },
  -- TODO: Remove this when Lazyvim fixes this issue:
  -- https://github.com/LazyVim/LazyVim/issues/6039
  { "mason-org/mason-lspconfig.nvim", version = "^1.0.0" },
}
