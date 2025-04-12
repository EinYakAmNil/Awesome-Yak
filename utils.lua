local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")
local naughty = require("naughty")

local defaults = require("defaults")

local M = {}

function M.debug(v)
	naughty.notify({
		title = "debug",
		text = gears.debug.dump_return(v),
		timeout = 0,
	})
end

M.launch_app = function()
	awful.spawn(defaults.rofi_desktop)
end

M.set_wallpaper = function(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

M.change_wallpaper = function()
	awful.spawn.easy_async("wallpaper")
end

return M
