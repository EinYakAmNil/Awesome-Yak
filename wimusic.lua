local awful = require("awful")

awful.spawn.easy_async("wimusic status", function(out)
	-- local song = out 
	music_display.text = "𝅘𝅥𝅮♪  " .. out
	music_display.forced_width = music_display:get_preferred_size(1) + 20
end)
