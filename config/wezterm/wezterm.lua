--
-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
-- A GPU-accelerated cross-platform terminal emulator
-- https://wezfurlong.org/wezterm/

local b = require("utils/background")
local cs = require("utils/color_scheme")
local f = require("utils/font")
local h = require("utils/helpers")
local k = require("utils/keys")
local w = require("utils/wallpaper")

local wezterm = require("wezterm")
local act = wezterm.action

local config = {
  background = {
    w.get_wallpaper(),
    b.get_background(),
  },

  font_size = 20,
  font = f.get_font({
    "DankMono Nerd Font",
  }),

  harfbuzz_features = { "calt=0", "clig=0", "liga=0" },

  color_scheme = cs.get_color_scheme(),

  window_padding = {
    left = 20,
    right = 20,
    top = 20,
    bottom = 20,
  },

  set_environment_variables = {
    TERM_IS_DARK = h.is_dark() and "true" or "false",
    BAT_THEME = h.is_dark() and "Catppuccin-mocha" or "Catppuccin-latte",
    TERM = "xterm-256color",
    LG_CONFIG_FILE = h.is_dark()
        and "/Users/willian/Library/Application Support/lazygit/config.yml,/Users/willian/Library/Application Support/lazygit/themes/catppuccin/themes-mergable/mocha/yellow.yml"
      or "/Users/willian/Library/Application Support/lazygit/config.yml,/Users/willian/Library/Application Support/lazygit/themes/catppuccin/themes-mergable/latte/blue.yml",
  },

  -- general options
  adjust_window_size_when_changing_font_size = false,
  debug_key_events = false,
  enable_tab_bar = false,
  native_macos_fullscreen_mode = false,
  window_close_confirmation = "NeverPrompt",
  window_decorations = "RESIZE",

  -- keys
  keys = {
    k.cmd_key(".", k.multiple_actions(":ZenMode")),
    k.cmd_key("[", act.SendKey({ mods = "CTRL", key = "o" })),
    k.cmd_key("]", act.SendKey({ mods = "CTRL", key = "i" })),
    k.cmd_key("f", k.multiple_actions(":Grep")),
    k.cmd_key("H", act.SendKey({ mods = "CTRL", key = "h" })),
    k.cmd_key("i", k.multiple_actions(":SmartGoTo")),
    k.cmd_key("J", act.SendKey({ mods = "CTRL", key = "j" })),
    k.cmd_key("K", act.SendKey({ mods = "CTRL", key = "k" })),
    k.cmd_key("L", act.SendKey({ mods = "CTRL", key = "l" })),
    k.cmd_key("P", k.multiple_actions(":GoToCommand")),
    k.cmd_key("p", k.multiple_actions(":GoToFile")),
    k.cmd_key("j", k.multiple_actions(":GoToFile")),
    -- k.cmd_key("q", k.multiple_actions(":qa!")),
    k.cmd_to_tmux_prefix("1", "1"),
    k.cmd_to_tmux_prefix("2", "2"),
    k.cmd_to_tmux_prefix("3", "3"),
    k.cmd_to_tmux_prefix("4", "4"),
    k.cmd_to_tmux_prefix("5", "5"),
    k.cmd_to_tmux_prefix("6", "6"),
    k.cmd_to_tmux_prefix("7", "7"),
    k.cmd_to_tmux_prefix("8", "8"),
    k.cmd_to_tmux_prefix("9", "9"),
    k.cmd_to_tmux_prefix("`", "n"),
    k.cmd_to_tmux_prefix("b", "B"),
    k.cmd_to_tmux_prefix("C", "C"),
    k.cmd_to_tmux_prefix("d", "%"),
    k.cmd_to_tmux_prefix("D", '"'),
    k.cmd_to_tmux_prefix("G", "G"),
    k.cmd_to_tmux_prefix("g", "g"),
    k.cmd_to_tmux_prefix("k", "T"),
    k.cmd_to_tmux_prefix("l", "L"),
    k.cmd_to_tmux_prefix("n", '"'),
    k.cmd_to_tmux_prefix("N", "%"),
    k.cmd_to_tmux_prefix("o", "u"),
    k.cmd_to_tmux_prefix("T", "!"),
    k.cmd_to_tmux_prefix("t", "c"),
    k.cmd_to_tmux_prefix("w", "x"),
    k.cmd_to_tmux_prefix("z", "z"),

    k.cmd_key(
      "R",
      act.Multiple({
        act.SendKey({ key = "\x1b" }), -- escape
        k.multiple_actions(":source %"),
      })
    ),

    k.cmd_key(
      "s",
      act.Multiple({
        act.SendKey({ key = "\x1b" }), -- escape
        k.multiple_actions(":w"),
      })
    ),

    {
      mods = "CTRL|SHIFT",
      key = "q",
      action = k.multiple_actions(":qa!"),
    },

    {
      mods = "CMD|SHIFT",
      key = "}",
      action = act.Multiple({
        act.SendKey({ mods = "CTRL", key = "a" }),
        act.SendKey({ key = "n" }),
      }),
    },
    {
      mods = "CMD|SHIFT",
      key = "{",
      action = act.Multiple({
        act.SendKey({ mods = "CTRL", key = "a" }),
        act.SendKey({ key = "p" }),
      }),
    },

    {
      mods = "CTRL",
      key = "Tab",
      action = act.Multiple({
        act.SendKey({ mods = "CTRL", key = "a" }),
        act.SendKey({ key = "n" }),
      }),
    },

    {
      mods = "CTRL|SHIFT",
      key = "Tab",
      action = act.Multiple({
        act.SendKey({ mods = "CTRL", key = "a" }),
        act.SendKey({ key = "n" }),
      }),
    },

    {
      mods = "CMD",
      key = "~",
      action = act.Multiple({
        act.SendKey({ mods = "CTRL", key = "a" }),
        act.SendKey({ key = "p" }),
      }),
    },

    { key = "LeftArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bb" }) },

    { key = "RightArrow", mods = "OPT", action = wezterm.action({ SendString = "\x1bf" }) },
  },
}

wezterm.on("user-var-changed", function(window, pane, name, value)
  local overrides = window:get_config_overrides() or {}
  wezterm.log_info("name", name)
  wezterm.log_info("value", value)

  if name == "T_SESSION" then
    local session = value
    wezterm.log_info("is session", session)
    overrides.background = {
      w.set_tmux_session_wallpaper(value),
      {
        source = {
          Gradient = {
            colors = { "#000000" },
          },
        },
        width = "100%",
        height = "100%",
        opacity = 0.95,
      },
    }
  end

  if name == "ZEN_MODE" then
    local incremental = value:find("+")
    local number_value = tonumber(value)
    if incremental ~= nil then
      while number_value > 0 do
        window:perform_action(wezterm.action.IncreaseFontSize, pane)
        number_value = number_value - 1
      end
    elseif number_value < 0 then
      window:perform_action(wezterm.action.ResetFontSize, pane)
      overrides.font_size = nil
    else
      overrides.font_size = number_value
    end
  end
  if name == "DIFF_VIEW" then
    local incremental = value:find("+")
    local number_value = tonumber(value)
    if incremental ~= nil then
      while number_value > 0 do
        window:perform_action(wezterm.action.DecreaseFontSize, pane)
        number_value = number_value - 1
      end
    elseif number_value < 0 then
      window:perform_action(wezterm.action.ResetFontSize, pane)
      overrides.background = nil
      overrides.font_size = nil
    else
      overrides.font_size = number_value
    end
  end
  window:set_config_overrides(overrides)
end)

return config
