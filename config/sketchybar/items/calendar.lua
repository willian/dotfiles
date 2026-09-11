local sbar = require("sketchybar")
local colors = require("colors")

local calendar = sbar.add("item", "calendar", {
	position = "right",
	update_freq = 60,
	icon = { drawing = false },
	background = { color = colors.white_alpha },
	label = { color = colors.item_bg, padding_left = 16, padding_right = 12 },
})

local function update_date()
	sbar.exec("date +'%a %d %b'", function(out)
		calendar:set({ label = { string = out:match("^%s*(.-)%s*$") } })
	end)
end

calendar:subscribe({ "forced", "routine" }, update_date)
update_date()

return calendar
