local awful = require("awful")
local bar = require("statusbar")

awful.spawn.easy_async("wivolume status", function(out)
	bar.vol_display.text = out
end)

