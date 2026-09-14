local sbar = require("sketchybar")
local colors = require("colors")

local clock = sbar.add("item", "clock", {
	position = "right",
	update_freq = 5,
	icon = { drawing = false },
	background = { color = colors.white_alpha },
	label = { color = colors.item_bg, padding_left = 12, padding_right = 16 },
})

local function update_time()
	sbar.exec("date +'%I:%M %p'", function(out)
		clock:set({ label = { string = out:match("^%s*(.-)%s*$") } })
	end)
end

clock:subscribe({ "forced", "routine" }, update_time)
clock:subscribe("mouse.clicked", function()
	local config_dir = os.getenv("CONFIG_DIR") or (os.getenv("HOME") .. "/.config/sketchybar")
	sbar.exec(config_dir .. "/world-clock/toggle")
end)
update_time()

return clock
