local sbar = require("sketchybar")
local colors = require("colors")
local separator = require("helpers.separator")

local calendar = require("items.calendar")
local datetime_separator = separator("datetime_separator", {
	position = "right",
	padding_left = 0,
	padding_right = 6,
	icon = { align = "center", color = colors.white_alpha, string = "", width = 16 },
})
local clock = require("items.clock")
local items = { calendar, datetime_separator, clock }

local function is_builtin_display(info)
	return info and info:match("Built%-in")
end

local function update_position()
	sbar.exec("system_profiler SPDisplaysDataType", function(info)
		local has_builtin = is_builtin_display(info)
		local display_count = 0
		for _ in info:gmatch("Graphics.-Display") do
			display_count = display_count + 1
		end
		if display_count == 0 then
			display_count = select(2, info:gsub("Display Type", ""))
		end

		local position = (display_count > 1 or not has_builtin) and "center" or "right"
		for _, item in ipairs(items) do
			item:set({ position = position })
		end
	end)
end

calendar:subscribe("display_change", update_position)
update_position()
