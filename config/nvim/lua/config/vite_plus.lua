local M = {}

function M.root(bufnr)
  local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
  for _, path in ipairs(vim.fs.find("package.json", { path = dir, upward = true, type = "file", limit = math.huge })) do
    local ok, package = pcall(function()
      return vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
    end)
    if ok and type(package) == "table" then
      for _, key in ipairs({ "dependencies", "devDependencies", "optionalDependencies" }) do
        local dependencies = package[key]
        if type(dependencies) == "table" and dependencies["vite-plus"] then
          return vim.fs.dirname(path)
        end
      end
    end
  end
end

function M.package_dir(root)
  local dir = vim.uv.fs_realpath(root .. "/node_modules/vite-plus")
  if dir and vim.fn.executable(dir .. "/bin/vp") == 1 then
    return dir
  end
end

return M
