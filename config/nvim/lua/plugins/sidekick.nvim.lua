return {
  "folke/sidekick.nvim",
  keys = {
    {
      "<leader>ac",
      function()
        require("sidekick.cli").toggle({ name = "claude", focus = true })
      end,
      desc = "Sidekick Toggle Claude",
    },
    {
      "<leader>ag",
      function()
        require("sidekick.cli").toggle({ name = "codex", focus = true })
      end,
      desc = "Sidekick Toggle Codex",
    },
    {
      "<leader>ai",
      function()
        require("sidekick.cli").toggle({ name = "pi", focus = true })
      end,
      desc = "Sidekick Toggle Pi",
    },
    {
      "<leader>ao",
      function()
        require("sidekick.cli").toggle({ name = "opencode", focus = true })
      end,
      desc = "Sidekick Toggle Opencode",
    },
  },
  opts = {
    cli = {
      mux = { enabled = false },
      -- mux = {
      --   backend = "tmux",
      --   enabled = true,
      --   split = {
      --     size = 0.35,
      --   },
      -- },
      prompts = {
        commit = "/commit\nEnsure it does not give so much in-the-weeds code details.",
        diagnostics = "Fix these diagnostics in {file}:\n{diagnostics}",
        explain = "Explain {this} and its context",
        optimize = "Optimize {this} for performance and readability",
        optimize_all = "Optimize all changed files for performance and readability",
        create_pr = "/pr\nEnsure it does not give so much in-the-weeds code details.\nDO NOT COPY/PASTE COMMIT MESSAGES INTO THE PR DESCRIPTION.",
        pr_review = "/pr-review",
        review = "Review {file} for correctness and readability",
        simplify = "Read the guidelines from CLAUDE.md or AGENTS.md file. The guidelines file can be located in parent directories (up to repository root). Then, simplify {file} based on the guidelines. Later, run formatters and linters on the modified files (if any).",
        tests = "Add tests for {this}",
      },
      win = {
        keys = {
          escape = { "<Esc>", "<c-[>", mode = "t" },
        },
      },
    },
    nes = {
      enabled = false, -- Disable Next Edit Suggestions (requires GitHub Copilot subscription)
    },
  },
}
