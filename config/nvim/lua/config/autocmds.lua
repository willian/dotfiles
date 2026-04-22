-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Reload tmux after change its configurations
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*tmux.conf" },
  command = "execute 'silent !tmux source <afile> --silent'",
})

-- Clear yazi's cache after change its configurations
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "yazi.toml" },
  command = "execute 'silent !yazi --clear-cache'",
})

-- Reload zsh after change its configurations
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*zshrc", "config.zsh" },
  command = "execute 'silent !source <afile> --silent'",
})

-- Reload AeroSpace after change its configurations
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "aerospace.toml" },
  command = "execute 'silent !aerospace reload-config'",
})

-- Reload SketchyBar after change its configurations
vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    local file_path = vim.fn.expand("%:p:h")
    local is_sketchybar = file_path:match("sketchybar")
    if is_sketchybar then
      vim.api.nvim_command("silent !sketchybar --reload")
    end
  end,
})

-- Auto-recover from swap files and delete swap after saving
vim.api.nvim_create_autocmd("SwapExists", {
  callback = function()
    vim.v.swapchoice = "r"
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    local swapname = vim.fn.swapname("")
    if swapname ~= "" and vim.fn.filereadable(swapname) == 1 then
      vim.fn.delete(swapname)
    end
  end,
})

-- Auto-set colorcolumn based on formatter configs (Prettier, StyLua, RuboCop)
local cache = {}

local formatters = {
  prettier = {
    configs = { ".prettierrc", ".prettierrc.json", ".prettierrc.yml", ".prettierrc.yaml",
                ".prettierrc.json5", ".prettierrc.js", ".prettierrc.cjs", ".prettierrc.mjs",
                "prettier.config.js", "prettier.config.cjs", "prettier.config.mjs" },
    pattern = 'printWidth%s*[:=]%s*(%d+)',
    json_key = "printWidth",
    default = 80,
  },
  stylua = {
    configs = { "stylua.toml", ".stylua.toml" },
    pattern = "column_width%s*=%s*(%d+)",
    default = 120,
  },
  rubocop = {
    configs = { ".rubocop.yml", ".rubocop.yaml", "rubocop.yml" },
    pattern = "Layout/LineLength:%s*\n?%s*Max:%s*(%d+)",
    default = 120,
  },
}

local function get_line_length(dir, formatter_name, formatter)
  local cache_key = dir .. "/" .. formatter_name
  if cache[cache_key] then return cache[cache_key] end

  -- Find config file
  local config_path
  for _, name in ipairs(formatter.configs) do
    local path = dir .. "/" .. name
    if vim.fn.filereadable(path) == 1 then
      config_path = path
      break
    end
  end

  if not config_path then return nil end

  -- Parse config file
  local content = table.concat(vim.fn.readfile(config_path), "\n")
  local value

  if formatter.json_key then
    local ok, json = pcall(vim.json.decode, content)
    if ok and json[formatter.json_key] then
      value = tonumber(json[formatter.json_key])
    end
  end

  if not value then
    value = tonumber(content:match(formatter.pattern))
  end

  cache[cache_key] = value
  return value
end

local filetype_map = {
  ["javascript"] = "prettier", ["javascriptreact"] = "prettier",
  ["typescript"] = "prettier", ["typescriptreact"] = "prettier",
  ["json"] = "prettier", ["jsonc"] = "prettier",
  ["yaml"] = "prettier", ["markdown"] = "prettier",
  ["css"] = "prettier", ["scss"] = "prettier",
  ["html"] = "prettier", ["vue"] = "prettier",
  ["svelte"] = "prettier", ["astro"] = "prettier",
  ["lua"] = "stylua",
  ["ruby"] = "rubocop",
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  callback = function(args)
    local formatter_name = filetype_map[vim.bo[args.buf].filetype]
    if not formatter_name then return end

    local formatter = formatters[formatter_name]
    local dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(args.buf), ":p:h")
    local value = get_line_length(dir, formatter_name, formatter) or formatter.default

    vim.opt_local.colorcolumn = tostring(value)
  end,
})

-- Clear cache on buffer write to config files
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = { "*prettier*", "*stylua*", "*rubocop*" },
  callback = function()
    cache = {}
  end,
})
