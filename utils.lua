local awful = require("awful")
utils = {}

utils.get_song = function()
	awful.spawn.easy_async("wimusic status", function(stdout)
		if string.len(stdout) > 1 then
			music_display.text = "𝅘𝅥𝅮♪  " .. stdout
		else
			music_display.text = "No songs playing "
		end
		music_display.forced_width = music_display:get_preferred_size(1) + 20
	end)
end

utils.toggle_song = function()
	awful.spawn.easy_async("wimusic toggle", function() end)
end

utils.quit_mpv = function()
	awful.spawn.easy_async("wimusic quit", function() end)
end

utils.get_vol = function()
	awful.spawn.easy_async("wivolume status", function(stdout)
		if string.len(stdout) > 2 then
			vol_display.text = "󰕾 " .. stdout
		else
			utils.get_vol()
		end
	end)
end

utils.volmixer = function()
	awful.spawn.easy_async("wivolume mixer", function() end)
end

utils.volpavu = function()
	awful.spawn.easy_async("wivolume pavu", function() end)
end

utils.voldec = function()
	awful.spawn.easy_async("wivolume dec", function()
		awful.spawn.easy_async("wivolume status", function(stdout)
			vol_display.text = "󰕾 " .. stdout
		end)
	end)
end

utils.volinc = function()
	awful.spawn.easy_async("wivolume inc", function()
		awful.spawn.easy_async("wivolume status", function(stdout)
			vol_display.text = "󰕾 " .. stdout
		end)
	end)
end

return utils
