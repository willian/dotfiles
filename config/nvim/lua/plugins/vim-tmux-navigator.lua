return {
  {
    "christoomey/vim-tmux-navigator",
    cond = function()
      return vim.env.TMUX ~= nil or vim.env.HERDR_PANE_ID == nil
    end,
    init = function()
      vim.g.tmux_navigator_no_mappings = 1 -- mappings live in config/keymaps.lua
    end,
  },
  {
    "bojackduy/nvim-herdr-navigation",
    submodules = false,
    cond = function()
      return vim.env.TMUX == nil and vim.env.HERDR_PANE_ID ~= nil
    end,
    event = "VeryLazy",
    init = function(plugin)
      vim.opt.rtp:prepend(plugin.dir .. "/nvim-herdr-navigation")
    end,
    config = function()
      vim.schedule(function()
        require("herdr-navigation").setup({
          keybindings = {
            left = "<C-h>",
            down = "<C-j>",
            up = "<C-k>",
            right = "<C-l>",
          },
        })
      end)
    end,
  },
}
