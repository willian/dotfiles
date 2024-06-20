return {
  "akinsho/toggleterm.nvim",
  lazy = false,
  keys = {
    { "<leader>T1", "<cmd>1ToggleTerm<CR>", desc = "Toggle terminal #1" },
    { "<leader>T2", "<cmd>2ToggleTerm<CR>", desc = "Toggle terminal #2" },
    { "<leader>T3", "<cmd>3ToggleTerm<CR>", desc = "Toggle terminal #3" },
    { "<leader>T4", "<cmd>4ToggleTerm<CR>", desc = "Toggle terminal #4" },
  },
  opts = {
    size = 20,
    open_mapping = [[\\]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = "curved",
      winblend = 0,
      highlights = {
        border = "Normal",
        background = "Normal",
      },
    },
  },
  config = function(_, opts)
    local toggleterm = require("toggleterm")

    toggleterm.setup(opts)

    function _G.set_terminal_keymaps()
      local keymap_opts = { noremap = true }
      vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], keymap_opts)
      vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], keymap_opts)
      vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], keymap_opts)
      vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], keymap_opts)
    end

    vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
  end,
}
