local awful = require("awful")
local bar = require("statusbar")
local scripts = require("scripts")

awful.spawn.easy_async(scripts.volume .. "status", function(out)
	bar.vol_display.text = out
end)
