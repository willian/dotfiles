return {
  "folke/sidekick.nvim",
  dependencies = {
    "willian/sidekick-rex.nvim",
  },
  config = function(_, opts)
    require("sidekick-rex").setup() -- registers the rex backend; a no-op outside Rex
    require("sidekick").setup(opts)
  end,
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
        require("sidekick.cli").toggle({ name = "copilot", focus = true })
      end,
      desc = "Sidekick Toggle Copilot CLI",
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
    {
      "<leader>ax",
      function()
        require("sidekick.cli").toggle({ name = "codex", focus = true })
      end,
      desc = "Sidekick Toggle Codex",
    },
  },
  opts = {
    cli = {
      mux = {
        backend = vim.env.REX_SESSION and "rex" or "tmux",
        create = "split",
        enabled = true,
        split = { size = 0.40 },
      },
      -- the mux spawns tools outside nvim's env; mise exec re-applies per-directory env (e.g. CLAUDE_CONFIG_DIR)
      tools = {
        claude = { cmd = { "mise", "exec", "--", "claude" } },
        codex = { cmd = { "mise", "exec", "--", "codex" } },
        copilot = { cmd = { "mise", "exec", "--", "copilot" } },
        pi = { cmd = { "mise", "exec", "--", "pi" } },
        opencode = { cmd = { "mise", "exec", "--", "opencode" } },
      },
      prompts = {
        commit = "Invoke the `commit` skill. Ensure it does not give so much in-the-weeds code details.",
        create_pr = "Invoke the `pr-create` skill. Ensure it does not give so much in-the-weeds code details. DO NOT COPY/PASTE COMMIT MESSAGES INTO THE PR DESCRIPTION.",
        diagnostics = "Fix these diagnostics in {file}:\n{diagnostics}",
        explain = "Explain {this} and its context",
        optimize = "Optimize {this} for performance and readability",
        optimize_all = "Optimize all changed files for performance and readability",
        pr_review = "Invoke the `pr-review` skill.",
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
