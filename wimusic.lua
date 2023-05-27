local naughty = require("naughty")
local beautiful = require("beautiful")
local awful = require("awful")

local function debug(string)
	naughty.notify({ title = string })
end

local s = awful.screen.focused()
awful.spawn.easy_async("Musik", function(out)
	music_display.text = out .. " "
	music_display.forced_width = music_display:get_preferred_size(1) + 50
end)
