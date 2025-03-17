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
    ["marilari88/neotest-vitest"] = {
      filter_dir = function(name, rel_path, root)
        return name ~= "node_modules"
      end,
    },
    ["nvim-neotest/neotest-jest"] = {
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
    ["neotest-rspec"] = {
      rspec_cmd = function()
        return vim
          .iter({
            "bundle",
            "exec",
            "rspec",
          })
          :flatten()
      end,
    },
    ["thenbe/neotest-playwright"] = {
      filter_dir = function(name, rel_path, root)
        return name ~= "node_modules"
      end,
    },
    ["zidhuss/neotest-minitest"] = {
      test_cmd = function()
        return vim
          .iter({
            "bundle",
            "exec",
            "rails",
            "test",
          })
          :flatten()
      end,
    },
  },
}
