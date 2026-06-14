local sbar = require("sketchybar")
local colors = require("colors")
local separator = require("helpers.separator")

local media_sep = separator("media_separator", { drawing = false })

local media = sbar.add("item", "media", {
	position = "left",
	background = { color = colors.white_alpha },
	icon = {
		color = colors.item_bg,
		padding_left = 16,
		string = "",
	},
	label = {
		color = colors.item_bg,
		padding_left = 4,
		padding_right = 16,
		max_chars = 30,
	},
	padding_right = 8,
	update_freq = 5,
	drawing = false,
})

local SPOTIFY_SCRIPT = [[
	tell application "System Events"
		set spotifyRunning to (name of processes) contains "Spotify"
	end tell
	if spotifyRunning then
		tell application "Spotify"
			if player state is playing then
				set trackName to name of current track
				set trackArtist to artist of current track
				return trackName & " - " & trackArtist
			end if
		end tell
	end if
	return ""
]]

local function update_media()
	sbar.exec("osascript -e '" .. SPOTIFY_SCRIPT .. "'", function(output)
		local display = output and output:match("^%s*(.-)%s*$")
		if display and display ~= "" then
			media_sep:set({ drawing = true })
			media:set({
				label = { string = display },
				drawing = true,
			})
		else
			media_sep:set({ drawing = false })
			media:set({ drawing = false })
		end
	end)
end

media:subscribe("routine", update_media)

media:subscribe("mouse.clicked", function()
	sbar.exec("open -a Spotify")
end)
