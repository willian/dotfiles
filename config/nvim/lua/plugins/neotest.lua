---@diagnostic disable: unused-local
return {
  "nvim-neotest/neotest",
  dependencies = {
    "marilari88/neotest-vitest",
    "nvim-neotest/neotest-jest",
    "olimorris/neotest-rspec",
    "thenbe/neotest-playwright",
    "zidhuss/neotest-minitest",
  },
  opts = {
    adapters = {
      ["neotest-vitest"] = {
        filter_dir = function(name, rel_path, root)
          return name ~= "node_modules"
        end,
      },
      ["neotest-jest"] = {
        jestCommand = "npm test --",
        jestConfig = "jest.config.js",
        env = { CI = true },
        cwd = function()
          return vim.fn.getcwd()
        end,
        filter_dir = function(name, rel_path, root)
          return name ~= "node_modules"
        end,
      },
      ["neotest-playwright"] = {
        filter_dir = function(name, rel_path, root)
          return name ~= "node_modules"
        end,
      },
      "neotest-rspec",
      "neotest-minitest",
    },
  },
}
