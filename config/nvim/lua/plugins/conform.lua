return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft.ruby = { "prettier" }
    for _, ft in ipairs({
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "json",
      "jsonc",
      "css",
      "scss",
      "less",
      "html",
      "vue",
      "svelte",
      "handlebars",
      "graphql",
      "markdown",
      "yaml",
    }) do
      local formatters = opts.formatters_by_ft[ft] or { "prettier" }
      opts.formatters_by_ft[ft] = function(bufnr)
        return require("config.vite_plus").root(bufnr) and { name = "oxfmt" } or formatters
      end
    end
  end,
}
