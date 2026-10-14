return {
  "christoomey/vim-tmux-navigator",
  init = function()
    vim.g.tmux_navigator_no_mappings = 1 -- mappings live in config/keymaps.lua
  end,
}
