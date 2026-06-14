local sbar = require("sketchybar")
local colors = require("colors")

sbar.bar({
	blur_radius = 5,
	color = colors.bar,
	height = 38,
	padding_left = 16,
	padding_right = 16,
	position = "top",
	sticky = "off",
})

sbar.default({
	background = {
		color = colors.item_bg_alpha,
		corner_radius = 12,
		height = 24,
	},
	icon = {
		align = "center",
		font = "CaskaydiaCove Nerd Font:Regular:14.0",
	},
	label = {
		align = "center",
		color = colors.white,
		font = "CaskaydiaCove Nerd Font:Regular:14.0",
		highlight_color = colors.accent,
	},
})

require("items.spaces")
require("items.front_app")
require("items.media")
require("items.clock")
require("items.battery")
require("items.bluetooth")
require("items.wifi")
require("items.volume")
require("items.display")
