os.setlocale("de_DE.UTF8")
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
--My own library
local utils = require("utils")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal("debug::error", function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})
		in_error = false
	end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
local theme_path = gears.filesystem.get_xdg_config_home() .. "awesome/themes/yak/theme.lua"
beautiful.init(theme_path)

defaults = require("defaults")
require("layouts")
require("keybinds")
require("clients")
require("cursor")

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ defaults.modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ defaults.modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewprev(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewnext(t.screen)
	end)
)

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(-1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(1)
	end)
)

local function set_wallpaper(s)
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

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

music_display = wibox.widget.textbox()
vol_display = wibox.widget.textbox()

awful.screen.connect_for_each_screen(function(s)
	separator = wibox.widget.separator({
		thickness = 5,
		forced_width = 20,
	})
	scroller = wibox.widget({
		layout = wibox.container.scroll.horizontal,
		max_size = 100,
		step_function = wibox.container.scroll.step_functions.linear_increase,
		speed = 50,
		fps = 60,
		buttons = gears.table.join(awful.button({}, 1, utils.toggle_song), awful.button({}, 3, utils.toggle_song)),
		{
			widget = music_display,
			text = utils.get_song(),
			ellipsize = "none",
		},
	})
	volume = wibox.widget({
		widget = vol_display,
		text = utils.get_vol(),
		buttons = gears.table.join(
			awful.button({}, 1, utils.volmixer),
			awful.button({}, 3, utils.volpavu),
			awful.button({}, 4, utils.volinc),
			awful.button({}, 5, utils.voldec)
		),
	})
	-- Wallpaper
	set_wallpaper(s)

	-- Each screen has its own tag table.
	awful.tag({
		defaults.tagnames["console"],
		defaults.tagnames["browser"],
		defaults.tagnames["games"],
		defaults.tagnames["gameclients"],
		defaults.tagnames["videos"],
		defaults.tagnames["art"],
		defaults.tagnames["audio"],
		defaults.tagnames["communication"],
		defaults.tagnames["trash"],
	}, s, awful.layout.layouts[1])

	-- Create a promptbox for each screen
	s.mypromptbox = awful.widget.prompt()
	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
	})

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
	})

	-- hack offset status bar
	s.spacer = awful.wibar({
		position = "top",
		height = 5,
		width = 1,
		opacity = 0,
		screen = s,
	})
	s.spacer:setup()
	-- Create the wibox
	s.mywibox = awful.wibar({
		position = "top",
		height = 30,
		width = 1900,
		screen = s,
	})

	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		{
			-- Left widgets
			layout = wibox.layout.fixed.horizontal,
			defaults.mylauncher,
			s.mytaglist,
			separator,
			s.mypromptbox,
		},
		s.mytasklist, -- Middle widget
		{
			-- Right widgets
			layout = wibox.layout.fixed.horizontal,
			separator,
			volume,
			separator,
			scroller,
			separator,
			wibox.widget.systray(),
			mytextclock,
			s.mylayoutbox,
		},
	})
end)
-- }}}

local clientkeys = gears.table.join(
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
		-- The client currently has the input focus, so it cannot be
		-- minimized, since minimized clients can't have the focus.
		c.minimized = true
	end, { description = "minimize", group = "client" }),
	awful.key({ defaults.modkey, "Control" }, "m", function(c)
		c.maximized = not c.maximized
		c:raise()
	end, { description = "(un)maximize", group = "client" })
	-- awful.key({ defaults.modkey, "Control" }, "m", function(c)
	-- 	c.maximized_vertical = not c.maximized_vertical
	-- 	c:raise()
	-- end, { description = "(un)maximize vertically", group = "client" }),
	-- awful.key({ defaults.modkey, "Shift" }, "m", function(c)
	-- 	c.maximized_horizontal = not c.maximized_horizontal
	-- 	c:raise()
	-- end, { description = "(un)maximize horizontally", group = "client" })
)

local clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),
	awful.button({ defaults.modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ defaults.modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		awful.mouse.client.resize(c)
	end)
)

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	},

	-- No titlebars
	{
		rule_any = { type = { "normal", "dialog" } },
		properties = { titlebars_enabled = false },
	},

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
				"pinentry",
			},
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin", -- kalarm.
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
			},
			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true },
	},
	{
		rule_any = { class = { "firefox", "Brave-browser" } },
		properties = { tag = defaults.tagnames["browser"] },
	},
	{
		rule_any = { class = { "Steam", "Lutris" } },
		properties = { tag = defaults.tagnames["gameclients"] },
	},
	{
		rule_any = { name = { "Steam" } },
		properties = { tag = defaults.tagnames["gameclients"] },
	},
	{
		rule_any = { class = { "mpv" } },
		properties = { tag = defaults.tagnames["videos"] },
	},
	{
		rule_any = { class = { "krita", "Gimp-2.10", "Blender" } },
		properties = { tag = defaults.tagnames["art"] },
	},
	{
		rule = { class = "Blender", name = "Blender Preferences" },
		properties = { floating = true },
	},
	{
		rule = { class = "leagueclientux.exe" },
		properties = {
			tag = defaults.tagnames["gameclients"],
			floating = true,
		},
	},
	{
		rule_any = { class = { "league of legends.exe", "ShogunShowdownPrologue.x86_64", "retroarch" } },
		properties = {
			screen = 1,
			tag = defaults.tagnames["games"],
			fullscreen = true,
		},
	},
	{
		rule = { class = "league of legends.exe", "ShogunShowdownPrologue.x86_64", "retroarch" },
		properties = {
			screen = 1,
			tag = defaults.tagnames["games"],
			fullscreen = true,
		},
	},
	{
		rule_any = { class = { "Signal" } },
		properties = { tag = defaults.tagnames["communication"] },
	},
	{
		rule_any = { class = { "riotclientservices.exe", "leagueclient.exe" } },
		properties = { tag = defaults.tagnames["trash"] },
	},
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

beautiful.useless_gap = 5
