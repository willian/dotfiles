local sbar = require("sketchybar")
local colors = require("colors")

sbar.add("event", "aerospace_workspace_change")

local function trim(s)
	return s:match("^%s*(.-)%s*$")
end

-- Cache workspace list on startup (blocking is fine here since we're inside begin_config)
local focused = trim(io.popen("aerospace list-workspaces --focused"):read("*a"))
local workspaces = {}
for line in io.popen("aerospace list-workspaces --all"):lines() do
	local ws = trim(line)
	if ws ~= "" then
		table.insert(workspaces, ws)
	end
end

for _, sid in ipairs(workspaces) do
	local active = (sid == focused)

	local space = sbar.add("item", "space." .. sid, {
		position = "left",
		background = { drawing = active },
		click_script = "aerospace workspace " .. sid,
		icon = { drawing = false },
		label = { drawing = true, highlight = active, width = 24, string = sid },
		padding_right = 8,
	})

	space:subscribe("aerospace_workspace_change", function(env)
		local f = env.FOCUSED_WORKSPACE
		if not f or f == "" then
			-- Fallback: async query to avoid blocking the event thread
			sbar.exec("aerospace list-workspaces --focused", function(out)
				f = trim(out)
				space:set({
					background = { drawing = (sid == f) },
					label = { highlight = (sid == f) },
				})
			end)
			return
		end
		space:set({
			background = { drawing = (sid == f) },
			label = { highlight = (sid == f) },
		})
	end)
end

local separator = require("helpers.separator")
separator("space_separator")
