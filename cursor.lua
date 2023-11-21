local gears = require("gears")
local awful = require("awful")
local utils = require("utils")
local defaults = require("defaults")

-- {{{ Mouse bindings
root.buttons(
	gears.table.join(
		awful.button({}, 1, utils.launch_app),
		awful.button({ defaults.modkey }, 1, utils.change_wallpaper),
		awful.button({}, 3, function()
			defaults.mainmenu:toggle()
		end),
		awful.button({}, 4, awful.tag.viewprev),
		awful.button({}, 5, awful.tag.viewnext)
	)
)
-- }}}
--
local M = {}

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
	c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

M.buttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ defaults.modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ defaults.modkey }, 2, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.client.floating.toggle()
	end),
	awful.button({ defaults.modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

return M
