local sbar = require("sketchybar")
local colors = require("colors")

local battery = sbar.add("item", "battery", {
	position = "right",
	background = { color = colors.white_alpha },
	icon = { color = colors.item_bg, padding_left = 16 },
	label = { color = colors.item_bg, padding_left = 4, padding_right = 16 },
	padding_right = 8,
	update_freq = 120,
})

local ICONS = {
	charging = "",
	[100] = "",
	[90] = "",
	[60] = "",
	[30] = "",
	[10] = "",
	[0] = "",
}

local function pick_icon(pct, charging)
	if charging then
		return ICONS.charging
	end
	for threshold = 90, 0, -30 do
		if pct >= threshold then
			return ICONS[threshold]
		end
	end
	return ICONS[0]
end

local function update()
	sbar.exec("pmset -g batt", function(out)
		local pct = out:match("(%d+)%%")
		if not pct then
			return
		end
		local charging = out:match("AC Power") ~= nil
		battery:set({
			icon = { string = pick_icon(tonumber(pct), charging) },
			label = { string = pct .. "%" },
		})
	end)
end

battery:subscribe({ "forced", "routine", "system_woke", "power_source_change" }, update)

-- Force initial value so it renders immediately on startup
update()
