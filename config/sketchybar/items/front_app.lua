local sbar = require("sketchybar")
local colors = require("colors")
local icon_map = require("helpers.icon_map")

local front_app = sbar.add("item", "front_app", {
	position = "left",
	icon = {
		color = colors.accent,
		font = "sketchybar-app-font:Regular:14.0",
		padding_left = 16,
		padding_right = 8,
	},
	label = {
		color = colors.accent,
		padding_right = 16,
	},
})

local function set_front_app(name)
	front_app:set({
		label = { string = name },
		icon = { string = icon_map(name) },
	})
end

front_app:subscribe("front_app_switched", function(env)
	set_front_app(env.INFO)
end)

-- Set initial value asynchronously so we don't block startup
sbar.exec(
	"osascript -e 'tell application \"System Events\" to get name of first application process whose frontmost is true'",
	function(name)
		if name and name ~= "" then
			set_front_app(name:match("^%s*(.-)%s*$"))
		end
	end
)
