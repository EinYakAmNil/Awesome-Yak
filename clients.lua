local beautiful = require("beautiful")
local awful = require("awful")
local cursor = require("cursor")
local keybinds = require("keybinds")
local defaults = require("defaults")

require("awful.autofocus")

client.connect_signal("focus", function(c)
	c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
end)

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
			keys = keybinds.client_keys,
			buttons = cursor.buttons,
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
		rule_any = { class = { "DB Browser for SQLite", "qBittorrent" } },
		properties = { tag = defaults.tagnames["download"] },
	},
	{
		rule_any = { class = { "Steam", "Lutris" } },
		properties = { tag = defaults.tagnames["gameclients"] },
	},
	{
		rule_any = { class = { "mpv" } },
		properties = { tag = defaults.tagnames["videos"] },
	},
	{
		rule_any = { class = { "krita", "Gimp", "Blender" } },
		properties = { tag = defaults.tagnames["art"] },
	},
	{
		rule_any = { class = { "calibre", "Zathura" } },
		properties = { tag = defaults.tagnames["docs"] },
	},
	{
		rule = { class = "Blender", name = "Preferences" },
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
		rule_any = {
			class = {
				"steam_app_.*",
				"league of legends.exe",
				"ShogunShowdownPrologue.x86_64",
				"medieval2.exe",
				"assassinscreed_dx10.exe",
				"retroarch",
			},
		},
		properties = {
			screen = 1,
			tag = defaults.tagnames["games"],
			fullscreen = true,
		},
	},
	{
		rule_any = { class = { "Signal", "thunderbird" } },
		properties = { screen = 2, tag = defaults.tagnames["communication"] },
	},
	{
		rule_any = { class = { "riotclientservices.exe", "leagueclient.exe" } },
		properties = { tag = defaults.tagnames["download"] },
	},
	-- {
	-- 	rule = { class = "mpv", name = "awesome-mpv" },
	-- 	properties = { hidden = true },
	-- },
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
