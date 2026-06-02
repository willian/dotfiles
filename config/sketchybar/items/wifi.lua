local sbar = require("sketchybar")
local colors = require("colors")

local wifi = sbar.add("item", "wifi", {
	position = "right",
	background = { color = colors.white_alpha },
	click_script = "open x-apple.systempreferences:com.apple.wifi-settings-extension",
	icon = { color = colors.item_bg, padding_left = 16, padding_right = 16 },
	label = { drawing = false },
	padding_right = 8,
	update_freq = 30,
})

-- Single shell command instead of nested async waterfall
local function update()
	sbar.exec("networksetup -getairportpower en0 && ipconfig getifaddr en0 2>/dev/null", function(out, code)
		local connected = code == 0 and out and out:match("On") and out:match("%d+%.%d+%.%d+%.%d+")
		wifi:set({ icon = { string = connected and "󰖩" or "󰖪" } })
	end)
end

wifi:subscribe({ "forced", "routine", "system_woke", "wifi_change" }, update)
update()
