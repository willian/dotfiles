return {
  "NickvanDyke/opencode.nvim",
  dependencies = { "folke/snacks.nvim" },
  -- stylua: ignore
  keys = {
    { '<leader>ot', function() require('opencode').toggle() end, desc = 'Toggle embedded opencode', },
    -- { '<leader>oa', function() require('opencode').ask('@selection: ') end, desc = 'Ask opencode about selection', mode = 'v', },
    -- { '<leader>oa', function() require('opencode').ask() end, desc = 'Ask opencode', mode = 'n', },
    { '<leader>oA', function() require('opencode').ask('@buffer ') end, desc = 'Ask opencode about current buffer', mode = { 'n', 'x' }, },
    { '<leader>oa', function() require('opencode').ask('@this ') end, desc = 'Ask opencode', mode = { 'n', 'x' }, },
    { '<leader>op', function() require('opencode').select() end, desc = 'Execute opencode action...', mode = { 'n', 'x', }, },
    { '<leader>oR', function() require('opencode').prompt("Review this PR's code changes (`git diff main`). Check for: 1) trivial issues, 2) test inconsistencies, 3) typos and grammar errors in code, PR title, and description. Output results as a nested list grouped by commit hash, then by file.") end, desc = 'Review PR', },
    { '<leader>oT', function() require('opencode').prompt('Add tests for @this') end, desc = 'Test selection', mode = 'x', },
    { '<leader>od', function() require('opencode').prompt('Add documentation comments for @this') end, desc = 'Document selection', mode = 'x', },
    { '<leader>oe', function() require('opencode').prompt('Explain @this and its context') end, desc = 'Explain code near cursor', mode = { 'n', 'x' } },
    { '<leader>of', function() require('opencode').prompt('Fix these @diagnostics') end, desc = 'Fix errors', },
    { '<leader>oo', function() require('opencode').prompt('Optimize @this for performance and readability') end, desc = 'Optimize selection', mode = 'x', },
    { '<leader>or', function() require('opencode').prompt('Review @buffer for correctness and readability') end, desc = 'Review file', },
    { '<leader>os', function() require('opencode').prompt('Read the guidelines from CLAUDE.md or AGENTS.md file. The guidelines file can be located in parent directories (up to repository root). Then, simplify @buffer based on the guidelines. Later, run formatters and linters on the modified files (if any).') end, desc = 'Simplify file', },
    { '<leader>oS', function() require('opencode').command('session.share') end, desc = 'Share session', },
    { '<leader>oy', function() require('opencode').command('messages.copy') end, desc = 'Copy last message', },
    { '<S-C-u>',    function() require('opencode').command('session.half.page.up') end, desc = 'Scroll messages up', },
    { '<S-C-d>',    function() require('opencode').command('session.half.page.down') end, desc = 'Scroll messages down', },
  },
  config = function()
    vim.g.opencode_opts = {}

    -- Required for `opts.auto_reload`
    vim.opt.autoread = true
  end,
}
