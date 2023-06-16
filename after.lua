local awful = require("awful")
local bar = require("statusbar")
local beautiful = require("beautiful")
local utils = require("utils")

awful.screen.connect_for_each_screen(function(s)
	utils.set_wallpaper(s)
end)

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", utils.set_wallpaper)

beautiful.useless_gap = 5
bar.musicbox:reset_scrolling()
bar.musicbox:pause()
