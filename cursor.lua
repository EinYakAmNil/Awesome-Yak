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

M.keys = gears.table.join(
	awful.key({ defaults.modkey }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, { description = "toggle fullscreen", group = "client" }),
	awful.key({ defaults.modkey, "Shift" }, "q", function(c)
		c:kill()
	end, { description = "close", group = "client" }),
	awful.key(
		{ defaults.modkey, "Shift" },
		"f",
		awful.client.floating.toggle,
		{ description = "toggle floating", group = "client" }
	),
	awful.key({ defaults.modkey, "Control" }, "Return", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "move to master", group = "client" }),
	awful.key({ defaults.modkey }, "o", function(c)
		c:move_to_screen()
	end, { description = "move to screen", group = "client" }),
	awful.key({ defaults.modkey }, "t", function(c)
		c.ontop = not c.ontop
	end, { description = "toggle keep on top", group = "client" }),
	awful.key({ defaults.modkey }, "n", function(c)
		c.minimized = true
	end, { description = "minimize", group = "client" }),
	awful.key({ defaults.modkey, "Control" }, "m", function(c)
		c.maximized = not c.maximized
		c:raise()
	end, { description = "(un)maximize", group = "client" })
)

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
