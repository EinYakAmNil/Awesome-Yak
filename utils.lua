local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

local defaults = require("defaults")

local utils = {}

utils.launch_app = function()
	awful.spawn(defaults.dmenu_desktop)
end

utils.set_wallpaper = function(s)
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

utils.change_wallpaper = function()
	awful.spawn.easy_async("wallpaper")
end

return utils
