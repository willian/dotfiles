local sbar = require("sketchybar")
local colors = require("colors")

return function(name, opts)
	local config = {
		position = "left",
		background = { drawing = false },
		icon = { color = colors.white, align = "center", width = 24, string = "" },
		label = { drawing = false },
	}
	if opts then
		for k, v in pairs(opts) do
			config[k] = v
		end
	end
	return sbar.add("item", name, config)
end
