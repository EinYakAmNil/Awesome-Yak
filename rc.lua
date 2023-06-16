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
	musicbox = wibox.widget({
		layout = wibox.container.scroll.horizontal,
		max_size = 130,
		step_function = wibox.container.scroll.step_functions.linear_increase,
		speed = 50,
		fps = 60,
		buttons = gears.table.join(
			awful.button({}, 1, utils.songs_notify),
			awful.button({}, 2, utils.copy_song),
			awful.button({}, 3, utils.toggle_song),
			awful.button({}, 4, utils.prev_song),
			awful.button({}, 5, utils.next_song)
		),
		{
			widget = music_display,
			text = utils.get_song(),
			ellipsize = "none",
		},
	})
	volbox = wibox.widget({
		widget = vol_display,
		text = utils.get_vol(),
		buttons = gears.table.join(
			awful.button({}, 1, utils.volmixer),
			awful.button({}, 2, utils.default_vol),
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
		defaults.tagnames["docs"],
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
			volbox,
			separator,
			musicbox,
			separator,
			wibox.widget.systray(),
			mytextclock,
			s.mylayoutbox,
		},
	})
end)
-- }}}

beautiful.useless_gap = 5
musicbox:reset_scrolling()
musicbox:pause()
