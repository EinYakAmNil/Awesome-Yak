local awful = require("awful")
local gears = require("gears")
local help = require("help")

local bar = require("statusbar")
local defaults = require("defaults")
local utils = require("utils")

-- {{{ Key bindings
local globalkeys = gears.table.join(
	awful.key({ defaults.modkey, "Shift" }, "s", help.show_help, { description = "show help", group = "awesome" }),
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
		{ defaults.modkey },
		"u",
		awful.client.urgent.jumpto,
		{ description = "jump to urgent client", group = "client" }
	),

	-- media keys
	awful.key({}, "XF86AudioPlay", bar.toggle_song, { description = "Toggle music player", group = "media keys" }),
	awful.key({}, "XF86AudioStop", bar.quit_mpv, { description = "Quit music player", group = "media keys" }),
	awful.key({}, "XF86AudioNext", bar.next_song, { description = "Play next song in playlist", group = "media keys" }),
	awful.key(
		{},
		"XF86AudioPrev",
		bar.prev_song,
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
	awful.key({ defaults.modkey }, "m", function()
		awful.spawn("musictl select")
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
	awful.key({ defaults.modkey, "Shift" }, "v", function()
		awful.spawn("vpnctl")
	end, { description = "control VPNs via NetworkManager", group = "launcher" }),
	awful.key({ defaults.modkey }, "y", function()
		awful.spawn("ytmpv")
	end, { description = "play video in clipboard", group = "launcher" }),
	awful.key(
		{ defaults.modkey, "Control" },
		"r",
		awesome.restart,
		{ description = "reload awesome", group = "awesome" }
	),
	awful.key({ defaults.modkey, "Shift" }, "x", awesome.quit, { description = "quit awesome", group = "awesome" }),
	awful.key({ defaults.modkey, "Shift" }, "l", function()
		awful.tag.incmwfact(0.05)
	end, { description = "increase master width factor", group = "layout" }),
	awful.key({ defaults.modkey, "Shift" }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "decrease master width factor", group = "layout" }),
	awful.key({ defaults.modkey, "Control" }, "h", function()
		awful.tag.incncol(1, nil, true)
	end, { description = "increase the number of columns", group = "layout" }),
	awful.key({ defaults.modkey, "Control" }, "l", function()
		awful.tag.incncol(-1, nil, true)
	end, { description = "decrease the number of columns", group = "layout" }),
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

root.keys(globalkeys)
-- }}}
