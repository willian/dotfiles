local wezterm = require("wezterm")

local act = wezterm.action
local M = {}

M.multiple_actions = function(keys)
  local actions = {}
  for key in keys:gmatch(".") do
    table.insert(actions, act.SendKey({ key = key }))
  end
  table.insert(actions, act.SendKey({ key = "\n" }))
  return act.Multiple(actions)
end

M.key_table = function(mods, key, action)
  return {
    mods = mods,
    key = key,
    action = action,
  }
end

M.cmd_key = function(key, action)
  return M.key_table("CMD", key, act.SendKey(action))
end

M.cmd_to_nvim = function(key, action)
  return M.key_table(
    "CMD",
    key,
    act.Multiple({
      act.SendKey({ key = "\x1b" }), -- Escape
      M.multiple_actions(action),
    })
  )
end

M.cmd_to_tmux = function(key, tmux_key)
  return M.key_table(
    "CMD",
    key,
    act.Multiple({
      act.SendKey({ mods = "CTRL", key = "a" }), -- My tmux prefix
      act.SendKey({ key = tmux_key }),
    })
  )
end

return M
