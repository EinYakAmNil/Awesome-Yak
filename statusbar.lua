local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local defaults = require("defaults")

local M = {}

-- Elements on the left
local clock_display = wibox.widget.textclock()
local music_display = wibox.widget.textbox()
local vol_display = wibox.widget.textbox()

M.separator = wibox.widget.separator({
	thickness = 5,
	forced_width = 20,
})

M.get_song = function()
	awful.spawn.easy_async("wimusic status", function(stdout)
		if string.len(stdout) > 1 then
			music_display.text = "𝅘𝅥𝅮♪  " .. stdout
			M.musicbox:continue()
		else
			music_display.text = "No songs playing "
			M.musicbox:pause()
			M.musicbox:reset_scrolling()
		end
		music_display.forced_width = music_display:get_preferred_size(1) + 20
	end)
end

M.toggle_song = function()
	awful.spawn.easy_async("wimusic toggle", function() end)
end

M.next_song = function()
	awful.spawn.easy_async("wimusic next", function() end)
end

M.prev_song = function()
	awful.spawn.easy_async("wimusic prev", function() end)
end

M.songs_notify = function()
	awful.spawn.easy_async("wimusic notify", function() end)
end

M.copy_song = function()
	awful.spawn.easy_async("wimusic copy", function() end)
end

M.quit_mpv = function()
	awful.spawn.easy_async("wimusic quit", function()
		M.musicbox:pause()
		M.musicbox:reset_scrolling()
	end)
end

M.get_vol = function()
	awful.spawn.easy_async("wivolume status", function(stdout)
		if string.len(stdout) > 2 then
			vol_display.text = "󰕾 " .. stdout:gsub("[\r\n]", "")
		else
			M.get_vol()
		end
	end)
end

M.volmixer = function()
	awful.spawn.easy_async("wivolume mixer", function() end)
end

M.volpavu = function()
	awful.spawn.easy_async("wivolume pavu", function() end)
end

M.voldec = function()
	awful.spawn.easy_async("wivolume dec", function()
		awful.spawn.easy_async("wivolume status", function(stdout)
			vol_display.text = "󰕾 " .. stdout
		end)
	end)
end

M.volinc = function()
	awful.spawn.easy_async("wivolume inc", function()
		awful.spawn.easy_async("wivolume status", function(stdout)
			vol_display.text = "󰕾 " .. stdout
		end)
	end)
end

M.default_vol = function()
	awful.spawn.easy_async("wivolume default", function()
		awful.spawn.easy_async("wivolume status", function(stdout)
			vol_display.text = "󰕾 " .. stdout
		end)
	end)
end

M.musicbox = wibox.widget({
	layout = wibox.container.scroll.horizontal,
	max_size = 130,
	step_function = wibox.container.scroll.step_functions.linear_increase,
	speed = 50,
	fps = 60,
	buttons = gears.table.join(
		awful.button({}, 1, M.songs_notify),
		awful.button({}, 2, M.copy_song),
		awful.button({}, 3, M.toggle_song),
		awful.button({}, 4, M.prev_song),
		awful.button({}, 5, M.next_song)
	),
	{
		widget = music_display,
		text = M.get_song(),
		ellipsize = "none",
	},
})

M.volbox = wibox.widget({
	widget = vol_display,
	text = M.get_vol(),
	buttons = gears.table.join(
		awful.button({}, 1, M.volmixer),
		awful.button({}, 2, M.default_vol),
		awful.button({}, 3, M.volpavu),
		awful.button({}, 4, M.volinc),
		awful.button({}, 5, M.voldec)
	),
})

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

awful.screen.connect_for_each_screen(function(s)
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
		defaults.tagnames["download"],
	}, s, awful.layout.layouts[1])

	-- Create a promptbox for each screen
	s.prompt_widget = awful.widget.prompt()
	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.layout_display = awful.widget.layoutbox(s)
	s.layout_display:buttons(gears.table.join(
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
	s.tag_list = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
	})

	-- Create a tasklist widget
	s.task_list = awful.widget.tasklist({
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
	-- Create the wibox
	s.statusbar = awful.wibar({
		position = "top",
		stretch = true,
		screen = s,
	})

	s.statusbar:setup({
		layout = wibox.layout.align.horizontal,
		{
			-- Left widgets
			layout = wibox.layout.fixed.horizontal,
			defaults.launcher,
			s.tag_list,
			M.separator,
			s.prompt_widget,
		},
		s.task_list, -- Middle widget
		{
			-- Right widgets
			layout = wibox.layout.fixed.horizontal,
			M.separator,
			M.volbox,
			M.separator,
			M.musicbox,
			M.separator,
			wibox.widget.systray(),
			clock_display,
			s.layout_display,
		},
	})
end)

return M
