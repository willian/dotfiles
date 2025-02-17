-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.shell = "zsh"

vim.g.lazyvim_picker = "snacks"
-- Prettier formatter options
-- For reference: https://www.lazyvim.org/extras/formatting/prettier#options
vim.g.lazyvim_prettier_needs_config = false

-- Python lang options
-- For reference: https://www.lazyvim.org/extras/lang/python#options
vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff"

-- Ruby lang options
-- For reference: https://www.lazyvim.org/extras/lang/ruby#options
vim.g.lazyvim_ruby_lsp = "ruby_lsp"
vim.g.lazyvim_ruby_formatter = "rubocop"
