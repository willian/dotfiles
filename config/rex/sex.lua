-- sex loader for Rex. Loaded by plugin managers from lua/sex.lua, or written by `sex plugin install`.
-- On each config load it asks the installed sex for the plugin, so upgrades need no new copy.
local home = os.getenv("HOME") or ""
local user = os.getenv("USER") or ""
local candidates = {
  "/opt/homebrew/bin/sex",
  "/usr/local/bin/sex",
  home .. "/go/bin/sex",
  home .. "/.local/bin/sex",
  home .. "/.nix-profile/bin/sex",
  "/etc/profiles/per-user/" .. user .. "/bin/sex",
  "/run/current-system/sw/bin/sex",
  home .. "/.local/share/mise/shims/sex",
  home .. "/.asdf/shims/sex",
  "/usr/bin/sex",
}

local function exists(path)
  local f = io.open(path, "r")
  if f == nil then return false end
  f:close()
  return true
end

-- SEX_BIN stays out of the list: an unset variable would be nil and end ipairs early.
local function find()
  local env = os.getenv("SEX_BIN")
  if env ~= nil and env ~= "" then return env end
  for _, p in ipairs(candidates) do
    if exists(p) then return p end
  end
  return "sex"
end

local M = {}

-- rex.log does not show up in `rex config reload`, so a failed load keeps the actions
-- and reports the reason when one runs, and to `sex doctor` through sex_version.
local function broken(reason)
  local msg = "sex: " .. reason
  rex.log("warn", msg)
  for _, name in ipairs({ "sex_pick", "sex_activity", "sex_last" }) do
    rex.action{ name = name, title = name, run = function() error(msg, 0) end }
  end
  rex.action{ name = "sex_version", title = "sex_version", run = function() return { error = msg } end }
end

-- opts.bin overrides the search. All other options go to the plugin.
function M.setup(opts)
  local given = opts or {}
  opts = {}
  for k, v in pairs(given) do opts[k] = v end
  local found = opts.bin or find()
  local r, err = rex.exec({ found, "plugin", "--source" }, { timeout = 10 })
  if r == nil then return broken(found .. ": " .. tostring(err)) end
  if not r.ok then return broken(found .. " plugin --source failed, it may predate the loader: " .. r.stderr) end
  local chunk, lerr = loadstring(r.stdout, "=sex plugin")
  if chunk == nil then return broken(lerr) end
  opts.fallback_bin = found
  chunk().setup(opts)
end

return M
