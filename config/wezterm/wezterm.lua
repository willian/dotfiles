local wezterm = require("wezterm")

local colorscheme = require("utils.colorscheme")
local h = require("utils.helpers")
local keys = require("utils.keys")

local config = {
  default_prog = { "zsh", "-lc", 'sesh connect "Home "' },
  color_scheme = colorscheme.get(),
  colors = h.is_dark() and {
    cursor_bg = "#89b4fa",
    cursor_fg = "#1e1e2e",
    cursor_border = "#89b4fa",
  } or {
    cursor_bg = "#1e66f5",
    cursor_fg = "#eff1f5",
    cursor_border = "#1e66f5",
  },
  font = wezterm.font_with_fallback({
    {
      family = "CaskaydiaCove Nerd Font",
      weight = nil,
    },
  }),
  font_size = 20,
  -- disable ligatures in most fonts
  harfbuzz_features = { "calt=0", "clig=0", "liga=0" },

  -- UI settings
  adjust_window_size_when_changing_font_size = false,
  enable_tab_bar = false,
  native_macos_fullscreen_mode = false,
  window_background_opacity = 0.95,
  window_close_confirmation = "NeverPrompt",
  window_decorations = "RESIZE",
  window_padding = {
    left = 10,
    right = 0,
    top = 10,
    bottom = 0,
  },

  -- Keys
  keys = {
    keys.cmd_key("[", { mods = "CTRL", key = "o" }),
    keys.cmd_key("]", { mods = "CTRL", key = "i" }),

    -- Tmux
    keys.cmd_to_tmux("1", "1"),
    keys.cmd_to_tmux("2", "2"),
    keys.cmd_to_tmux("3", "3"),
    keys.cmd_to_tmux("4", "4"),
    keys.cmd_to_tmux("5", "5"),
    keys.cmd_to_tmux("6", "6"),
    keys.cmd_to_tmux("7", "7"),
    keys.cmd_to_tmux("8", "8"),
    keys.cmd_to_tmux("9", "9"),
    keys.cmd_to_tmux("d", "d"),
    keys.cmd_to_tmux("g", "g"),
    keys.cmd_to_tmux("k", "K"),
    keys.cmd_to_tmux("l", "L"),
    keys.cmd_to_tmux("n", '"'),
    keys.cmd_to_tmux("N", "%"),
    keys.cmd_to_tmux("o", "u"),
    keys.cmd_to_tmux("t", "c"),
    keys.cmd_to_tmux("T", "!"),
    keys.cmd_to_tmux("w", "x"),

    -- Neovim
    keys.cmd_to_nvim("f", " sg"),
    keys.cmd_to_nvim("p", " ff"),
    keys.cmd_to_nvim("R", ":source %"),
    keys.cmd_to_nvim("s", ":w"),

    keys.key_table("OPT", "LeftArrow", wezterm.action({ SendString = "\x1bb" })),
    keys.key_table("OPT", "RightArrow", wezterm.action({ SendString = "\x1bf" })),
  },
}

return config
