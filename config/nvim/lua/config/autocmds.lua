-- Reload tmux after change its configurations
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*tmux.conf" },
  command = "execute 'silent !tmux source <afile> --silent'",
})

-- Clear yazi's cache after change its configurations
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "yazi.toml" },
  command = "execute 'silent !yazi --clear-cache'",
})

-- Reload zsh after change its configurations
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*zshrc", "config.zsh" },
  command = "execute 'silent !source <afile> --silent'",
})
