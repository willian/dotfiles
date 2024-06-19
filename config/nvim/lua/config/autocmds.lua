-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*tmux.conf" },
  command = "execute 'silent !tmux source <afile> --silent'",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "yazi.toml" },
  command = "execute 'silent !yazi --clear-cache'",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*zshrc", "config.zsh" },
  command = "execute 'silent !source <afile> --silent'",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { ".yabairc" },
  command = "!yabai --restart-service",
})

vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { ".skhdrc" },
  command = "!brew services restart skhd",
})
