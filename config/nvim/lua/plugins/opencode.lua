return {
  "NickvanDyke/opencode.nvim",
  dependencies = { "folke/snacks.nvim" },
  -- stylua: ignore
  keys = {
    { '<leader>ot', function() require('opencode').toggle() end, desc = 'Toggle embedded opencode', },
    { '<leader>oA', function() require('opencode').ask('@file ') end, desc = 'Ask opencode about current file', mode = { 'n', 'v' }, },
    { '<leader>oa', function() require('opencode').ask('@selection: ') end, desc = 'Ask opencode about selection', mode = 'v', },
    { '<leader>oa', function() require('opencode').ask() end, desc = 'Ask opencode', mode = 'n', },
    { '<leader>op', function() require('opencode').select() end, desc = 'Select prompt', mode = { 'n', 'v', }, },
    { '<leader>oT', function() require('opencode').prompt('Add tests for @selection') end, desc = 'Test selection', mode = 'v', },
    { '<leader>od', function() require('opencode').prompt('Add documentation comments for @selection') end, desc = 'Document selection', mode = 'v', },
    { '<leader>oe', function() require('opencode').prompt('Explain @cursor and its context') end, desc = 'Explain code near cursor' },
    { '<leader>of', function() require('opencode').prompt('Fix these @diagnostics') end, desc = 'Fix errors', },
    { '<leader>oo', function() require('opencode').prompt('Optimize @selection for performance and readability') end, desc = 'Optimize selection', mode = 'v', },
    { '<leader>or', function() require('opencode').prompt('Review @file for correctness and readability') end, desc = 'Review file', },
    { '<leader>oR', function() require('opencode').prompt("Review this PR's code changes (`git diff main`). Check for: 1) trivial issues, 2) test inconsistencies, 3) typos and grammar errors in code, PR title, and description. Output results as a nested list grouped by commit hash, then by file.") end, desc = 'Review PR', },
    { '<leader>on', function() require('opencode').command('session_new') end, desc = 'New session', },
    { '<leader>oy', function() require('opencode').command('messages_copy') end, desc = 'Copy last message', },
    { '<S-C-u>',    function() require('opencode').command('messages_half_page_up') end, desc = 'Scroll messages up', },
    { '<S-C-d>',    function() require('opencode').command('messages_half_page_down') end, desc = 'Scroll messages down', },
  },
  config = function()
    vim.g.opencode_opts = {}

    -- Required for `opts.auto_reload`
    vim.opt.autoread = true
  end,
}
