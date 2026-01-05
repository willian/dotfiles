-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

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

-- Reload AeroSpace after change its configurations
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "aerospace.toml" },
  command = "execute 'silent !aerospace reload-config'",
})

-- Reload SketchyBar after change its configurations
vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    local file_path = vim.fn.expand("%:p:h")
    local is_sketchybar = file_path:match("sketchybar")
    if is_sketchybar then
      vim.api.nvim_command("silent !sketchybar --reload")
    end
  end,
})
