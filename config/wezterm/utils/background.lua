local wezterm = require("wezterm")

local cs = require("utils/color_scheme")
local h = require("utils/helpers")

local M = {}

M.get_background = function()
  local theme = wezterm.color.get_builtin_schemes()[cs.get_color_scheme()]

  return {
    source = {
      Gradient = {
        colors = { theme.background },
      },
    },
    width = "100%",
    height = "100%",
    opacity = h.is_dark() and 0.85 or 1,
  }
end

return M
