local sbar = require("sketchybar")
local colors = require("colors")

local volume = sbar.add("item", "volume", {
	position = "right",
	background = { color = colors.white_alpha },
	icon = { color = colors.item_bg, padding_left = 16 },
	label = { color = colors.item_bg, padding_left = 4, padding_right = 16 },
	padding_right = 8,
	-- SketchyBar emits volume_change on startup, but having a freq
	-- guarantees an initial label if the event is missed.
	update_freq = 60,
})

local ICONS = {
	high = "",
	med = "",
	low = "",
	mute = "",
}

local function set(vol)
	local icon = (vol >= 60) and ICONS.high or (vol >= 30) and ICONS.med or (vol > 0) and ICONS.low or ICONS.mute
	volume:set({ icon = { string = icon }, label = { string = vol .. "%" } })
end

volume:subscribe("volume_change", function(env)
	set(tonumber(env.INFO) or 0)
end)
volume:subscribe("mouse.clicked", function()
	sbar.exec("open x-apple.systempreferences:com.apple.Sound-Settings.extension")
end)
