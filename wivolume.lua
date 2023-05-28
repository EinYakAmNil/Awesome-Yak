local awful = require("awful")

awful.spawn.easy_async("wivolume status", function(out)
	vol_display.text = out
end)

