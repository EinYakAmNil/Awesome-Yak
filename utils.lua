local awful = require("awful")
utils = {}

utils.get_song = function()
	awful.spawn.easy_async("wimusic status", function(out)
		if string.len(out) > 1 then
			music_display.text = "𝅘𝅥𝅮♪  " .. out
		else
			music_display.text = "No songs playing "
		end
		music_display.forced_width = music_display:get_preferred_size(1) + 20
	end)
end

utils.volmixer = function()
	awful.spawn.easy_async("wivolume mixer")
end

utils.volpavu = function()
	awful.spawn.easy_async("wivolume pavu")
end

utils.voldec = function()
	awful.spawn.easy_async("wivolume dec", function()
		awful.spawn.easy_async("wivolume status", function(out)
			vol_display.text = "󰕾 " .. out
		end)
	end)
end

utils.volinc = function()
	awful.spawn.easy_async("wivolume inc", function()
		awful.spawn.easy_async("wivolume status", function(out)
			vol_display.text = "󰕾 " .. out
		end)
	end)
end

return utils
