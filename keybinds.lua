local awful = require("awful")
local gears = require("gears")
local help = require("help")

local bar = require("statusbar")
local widgets = require("widgets")
local defaults = require("defaults")
local utils = require("utils")

local M = {}

-- {{{ Key bindings
local globalkeys = gears.table.join(
	awful.key({ defaults.modkey }, "F1", help.show_help, { description = "show help", group = "awesome" }),
	awful.key({ defaults.modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
	awful.key({ defaults.modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
	awful.key(
		{ defaults.modkey },
		"Tab",
		awful.tag.history.restore,
		{ description = "Switch to previously focused Tabs", group = "tag" }
	),
	awful.key({ defaults.modkey }, "j", function()
		awful.client.focus.byidx(1)
	end, { description = "focus next by index", group = "client" }),
	awful.key({ defaults.modkey }, "k", function()
		awful.client.focus.byidx(-1)
	end, { description = "focus previous by index", group = "client" }),
	awful.key({ defaults.modkey }, "w", function()
		defaults.mainmenu:show()
	end, { description = "show main menu", group = "awesome" }),

	-- Layout manipulation
	awful.key({ defaults.modkey, "Shift" }, "j", function()
		awful.client.swap.byidx(1)
	end, { description = "swap with next client by index", group = "client" }),
	awful.key({ defaults.modkey, "Shift" }, "k", function()
		awful.client.swap.byidx(-1)
	end, { description = "swap with previous client by index", group = "client" }),
	awful.key({ defaults.modkey }, "l", function()
		awful.screen.focus_relative(1)
	end, { description = "focus the next screen", group = "screen" }),
	awful.key({ defaults.modkey }, "h", function()
		awful.screen.focus_relative(-1)
	end, { description = "focus the previous screen", group = "screen" }),
	awful.key(
		{ defaults.modkey, "Shift" },
		"u",
		awful.client.urgent.jumpto,
		{ description = "jump to urgent client", group = "client" }
	),

	-- media keys
	awful.key(
		{}, "XF86AudioPlay", widgets.music.toggle_song,
		{ description = "Toggle music player", group = "media keys" }
	),
	awful.key(
		{}, "XF86AudioStop", widgets.music.quit_mpv,
		{ description = "Quit music player", group = "media keys" }
	),
	awful.key(
		{}, "XF86AudioNext", widgets.music.next_song,
		{ description = "Play next song in playlist", group = "media keys" }
	),
	awful.key(
		{}, "XF86AudioPrev", widgets.music.prev_song,
		{ description = "Play previous song in playlist", group = "media keys" }
	),
	-- volume control
	awful.key({}, "XF86AudioLowerVolume", bar.voldec, { description = "Lower volume by 5%", group = "media keys" }),
	awful.key({}, "XF86AudioRaiseVolume", bar.volinc, { description = "Raise volume by 5%", group = "media keys" }),

	-- Standard program
	awful.key({ defaults.modkey }, "Return", function()
		awful.spawn(defaults.terminal)
	end, { description = "open a terminal", group = "launcher" }),
	awful.key(
		{ defaults.modkey, "Shift" }, "Return", utils.launch_app,
		{ description = "launch a desktop application", group = "launcher" }
	),
	awful.key({ defaults.modkey }, "b", function()
		awful.spawn(os.getenv("BROWSER"))
	end, { description = "open browser", group = "launcher" }),
	awful.key({ defaults.modkey }, "f", function()
		awful.spawn(defaults.lf)
	end, { description = "open file browser", group = "launcher" }),
	awful.key({ defaults.modkey }, "n", function()
		awful.spawn(defaults.nvimboat)
	end, { description = "open nvimboat", group = "launcher" }),
	awful.key({ defaults.modkey }, "d", function()
		awful.spawn("rofi-music-dl")
	end, { description = "play video in clipboard", group = "launcher" }),
	awful.key({ defaults.modkey }, "m", function()
		awful.spawn(defaults.rofi_music)
	end, { description = "music player with status bar integration", group = "launcher" }),
	awful.key({ defaults.modkey }, "p", function()
		awful.spawn("rofi-pass")
	end, { description = "Choose from password store using rofi", group = "launcher" }),
	awful.key({ defaults.modkey }, "r", function()
		awful.spawn("fix-inet")
	end, { description = "traceroute to fix routing issues", group = "launcher" }),
	awful.key({ defaults.modkey }, "s", function()
		awful.spawn(defaults.rofi_ssh)
	end, { description = "traceroute to fix routing issues", group = "launcher" }),
	awful.key({ defaults.modkey }, "u", function()
		awful.spawn("url-menu")
	end, { description = "control VPNs via NetworkManager", group = "launcher" }),
	awful.key({ defaults.modkey, "Shift" }, "v", function()
		awful.spawn("vpnctl")
	end, { description = "control VPNs via NetworkManager", group = "launcher" }),
	awful.key({ defaults.modkey }, "y", function()
		awful.spawn("ytmpv")
	end, { description = "play video in clipboard", group = "launcher" }),
	awful.key({ defaults.modkey }, "z", function()
		awful.spawn("rofi-zathura")
	end, { description = "open pdf file", group = "launcher" }),
	awful.key(
		{ defaults.modkey, "Control" },
		"r",
		awesome.restart,
		{ description = "reload awesome", group = "awesome" }
	),
	awful.key({ defaults.modkey, "Shift" }, "x", awesome.quit, { description = "quit awesome", group = "awesome" }),
	awful.key({ defaults.modkey, "Control" }, "l", function()
		awful.tag.incmwfact(0.05)
	end, { description = "increase master width factor", group = "layout" }),
	awful.key({ defaults.modkey, "Control" }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "decrease master width factor", group = "layout" }),
	awful.key({ defaults.modkey }, "space", function()
		awful.layout.inc(1)
	end, { description = "select next", group = "layout" }),
	awful.key({ defaults.modkey, "Shift" }, "space", function()
		awful.layout.inc(-1)
	end, { description = "select previous", group = "layout" }),
	awful.key({ defaults.modkey, "Control" }, "n", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			c:emit_signal("request::activate", "key.unminimize", { raise = true })
		end
	end, { description = "restore minimized", group = "client" }),

	awful.key({ defaults.modkey }, "Print", function()
		awful.spawn("flameshot screen")
	end, { description = "Capture current screen", group = "screenshot" }),
	awful.key({ defaults.modkey, "Shift" }, "Print", function()
		awful.spawn("flameshot gui")
	end, { description = "Manual capture", group = "screenshot" }),

	-- Prompt
	awful.key({ defaults.modkey, "Shift" }, "r", function()
		awful.prompt.run({
			prompt = "Run Lua code: ",
			textbox = awful.screen.focused().mypromptbox.widget,
			exe_callback = awful.util.eval,
			history_path = awful.util.get_cache_dir() .. "/history_eval",
		})
	end, { description = "lua execute prompt", group = "awesome" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = gears.table.join(
		globalkeys,
		-- View tag only.
		awful.key({ defaults.modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, { description = "view tag #" .. i, group = "tag" }),
		-- Toggle tag display.
		awful.key({ defaults.modkey, "Control" }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, { description = "toggle tag #" .. i, group = "tag" }),
		-- Move client to tag.
		awful.key({ defaults.modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move focused client to tag #" .. i, group = "tag" }),
		-- Toggle tag on focused client.
		awful.key({ defaults.modkey, "Control", "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, { description = "toggle focused client on tag #" .. i, group = "tag" })
	)
end

M.client_keys = gears.table.join(
	awful.key({ defaults.modkey, "Shift" }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, { description = "toggle fullscreen", group = "client" }),
	awful.key({ defaults.modkey, "Shift" }, "q", function(c)
		c:kill()
	end, { description = "close", group = "client" }),
	awful.key({ defaults.modkey, "Control" }, "Return", function(c)
		c:swap(awful.client.getmaster())
	end, { description = "move to master", group = "client" }),
	awful.key({ defaults.modkey, "Shift" }, "h", function(c)
		c:move_to_screen(screen[c.screen.index - 1])
	end, { description = "move to right screen", group = "client" }),
	awful.key({ defaults.modkey, "Shift" }, "l", function(c)
		c:move_to_screen(screen[c.screen.index + 1])
	end, { description = "move to left screen", group = "client" }),
	awful.key({ defaults.modkey, "Shift" }, "s", function(c)
		c.sticky = not c.sticky
	end, { description = "make client sticky", group = "client" }),
	awful.key({ defaults.modkey, "Shift" }, "n", function(c)
		c.minimized = true
	end, { description = "minimize", group = "client" }),
	awful.key({ defaults.modkey, "Control" }, "m", function(c)
		c.maximized = not c.maximized
		c:raise()
	end, { description = "(un)maximize", group = "client" })
)

root.keys(globalkeys)

return M
