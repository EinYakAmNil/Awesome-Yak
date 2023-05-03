-- local gears = require("gears")
-- local naughty = require("naughty")
local awful = require("awful")

local screen = awful.screen.focused()
-- local now = awful.screen.focused().selected_tags
-- local debug = gears.debug.dump_return
-- return debug(screen)

awful.tag.history.restore(screen, 1)
