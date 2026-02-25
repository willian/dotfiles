return {
  "NickvanDyke/opencode.nvim",
  version = "*",
  dependencies = {
    {
      "folke/snacks.nvim",
      optional = true,
      opts = {
        input = {},
        picker = {
          actions = {
            opencode_send = function(...)
              return require("opencode").snacks_picker_send(...)
            end,
          },
          win = {
            input = {
              keys = {
                ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
              },
            },
          },
        },
      },
    },
  },
  -- stylua: ignore
  keys = {
    { '<leader>ot', function() require('opencode').toggle() end, desc = 'Toggle opencode', mode = { 'n', 't' } },
    { '<leader>oa', function() require('opencode').ask('@this: ', { submit = true }) end, desc = 'Ask opencode about selection', mode = { 'n', 'x' } },
    { '<leader>oA', function() require('opencode').ask('@buffer ', { submit = true }) end, desc = 'Ask opencode about buffer', mode = { 'n', 'x' } },
    { '<leader>op', function() require('opencode').select() end, desc = 'Execute opencode action...', mode = { 'n', 'x' } },

    -- Operator for range/dot-repeat support
    { 'go',  function() return require('opencode').operator('@this ') end, desc = 'Add range to opencode', mode = { 'n', 'x' }, expr = true },
    { 'goo', function() return require('opencode').operator('@this ') .. '_' end, desc = 'Add line to opencode', expr = true },

    -- Prompts
    { '<leader>oR', function() require('opencode').prompt("Review this PR's code changes (`git diff main`). Check for: 1) trivial issues, 2) test inconsistencies, 3) typos and grammar errors in code, PR title, and description. Output results as a nested list grouped by commit hash, then by file.") end, desc = 'Review PR' },
    { '<leader>oT', function() require('opencode').prompt('test') end, desc = 'Test selection', mode = 'x' },
    { '<leader>od', function() require('opencode').prompt('document') end, desc = 'Document selection', mode = 'x' },
    { '<leader>oe', function() require('opencode').prompt('explain') end, desc = 'Explain code near cursor', mode = { 'n', 'x' } },
    { '<leader>of', function() require('opencode').prompt('fix') end, desc = 'Fix errors' },
    { '<leader>oo', function() require('opencode').prompt('optimize') end, desc = 'Optimize selection', mode = 'x' },
    { '<leader>or', function() require('opencode').prompt('Review @buffer for correctness and readability') end, desc = 'Review file' },
    { '<leader>os', function() require('opencode').prompt('Read the guidelines from CLAUDE.md or AGENTS.md file. The guidelines file can be located in parent directories (up to repository root). Then, simplify @buffer based on the guidelines. Later, run formatters and linters on the modified files (if any).') end, desc = 'Simplify file' },

    -- Commands
    { '<leader>oS', function() require('opencode').command('session.share') end, desc = 'Share session' },
    { '<S-C-u>',    function() require('opencode').command('session.half.page.up') end, desc = 'Scroll messages up' },
    { '<S-C-d>',    function() require('opencode').command('session.half.page.down') end, desc = 'Scroll messages down' },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {}

    -- Required for `opts.events.reload`
    vim.o.autoread = true
  end,
}
