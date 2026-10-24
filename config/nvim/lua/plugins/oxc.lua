return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    for _, name in ipairs({ "oxfmt", "oxlint" }) do
      opts.servers[name] = {
        mason = false,
        workspace_required = true,
        root_dir = function(bufnr, on_dir)
          local vite_plus = require("config.vite_plus")
          local root = vite_plus.root(bufnr)
          if root then
            if vite_plus.package_dir(root) then
              on_dir(root)
            else
              vim.notify_once(
                "Vite+ is not installed in " .. root .. "; install the project dependencies.",
                vim.log.levels.WARN
              )
            end
          end
        end,
        cmd = function(dispatchers, config)
          local package_dir =
            assert(require("config.vite_plus").package_dir(config.root_dir), "Vite+ executable is missing")
          local bin = package_dir .. "/node_modules/.bin/"
          return vim.lsp.rpc.start(
            { package_dir .. "/bin/vp", name == "oxfmt" and "fmt" or "lint", "--lsp" },
            dispatchers,
            {
              cwd = config.root_dir,
              env = { PATH = bin .. ":" .. vim.env.PATH },
            }
          )
        end,
      }
    end
    opts.servers.oxfmt.init_options = {
      settings = { ["fmt.configPath"] = "./vite.config.ts", run = "onSave" },
    }
    opts.servers.oxlint.settings = {
      run = "onType",
      typeAware = true,
      fixKind = "safe_fix",
      unusedDisableDirectives = "deny",
    }
  end,
}
