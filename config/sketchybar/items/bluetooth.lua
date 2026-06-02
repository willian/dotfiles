local sbar = require("sketchybar")
local colors = require("colors")

local bluetooth = sbar.add("item", "bluetooth", {
	position = "right",
	background = { color = colors.white_alpha },
	click_script = "open x-apple.systempreferences:com.apple.BluetoothSettings",
	icon = { color = colors.item_bg, padding_left = 16, padding_right = 16 },
	label = { drawing = false },
	padding_right = 8,
	update_freq = 5,
})

local ICONS = {
	connected = "󰂱",
	on = "󰂯",
	off = "󰂲",
}

local function update()
	sbar.exec(
		[[system_profiler SPBluetoothDataType -json 2>/dev/null | jq -r '.SPBluetoothDataType[0].controller_properties.controller_state as $state | (.SPBluetoothDataType[0].device_connected // []) | length as $count | [$state, $count] | @tsv']],
		function(result)
			if not result or result == "" then
				bluetooth:set({ icon = { string = ICONS.off } })
				return
			end

			local state, count = result:match("^(%S+)%s+(%d+)")
			count = tonumber(count) or 0

			local icon = ICONS.off
			if state == "attrib_on" then
				icon = count > 0 and ICONS.connected or ICONS.on
			end

			bluetooth:set({ icon = { string = icon } })
		end
	)
end

bluetooth:subscribe({ "forced", "routine" }, update)
update()
