local sbar = require("sketchybar")
local colors = require("colors")

sbar.add("item", "display", {
	position = "right",
	icon = { string = "󰍹", color = colors.item_bg, padding_left = 16, padding_right = 16 },
	label = { drawing = false },
	background = { color = colors.white_alpha },
	padding_right = 8,
	click_script = "open x-apple.systempreferences:com.apple.Displays-Settings.extension",
})
