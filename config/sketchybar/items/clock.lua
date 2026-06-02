local sbar = require("sketchybar")
local colors = require("colors")

local function is_builtin_display(info)
	return info and info:match("Built%-in")
end

local clock = sbar.add("item", "clock", {
	position = "right",
	update_freq = 5,
	icon = { drawing = false },
	background = { color = colors.white_alpha },
	label = { color = colors.item_bg, padding_left = 16, padding_right = 16 },
})

local function update_time()
	sbar.exec("date +'%a %d %b %I:%M %p'", function(out)
		clock:set({ label = { string = out:match("^%s*(.-)%s*$") } })
	end)
end

clock:subscribe({ "forced", "routine" }, update_time)

clock:subscribe("display_change", function()
	sbar.exec("system_profiler SPDisplaysDataType", function(info)
		local has_builtin = is_builtin_display(info)
		local display_count = 0
		for _ in info:gmatch("Graphics.-Display") do
			display_count = display_count + 1
		end
		if display_count == 0 then
			display_count = select(2, info:gsub("Display Type", ""))
		end

		clock:set({ position = (display_count > 1 or not has_builtin) and "center" or "right" })
	end)
end)

update_time()
