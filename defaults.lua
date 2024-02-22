local awful = require("awful")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local menubar = require("menubar")

M = {}
M.modkey = "Mod4"

M.terminal = os.getenv("TERM") or "kitty"
M.rofi_desktop = "rofi -show drun"
M.rofi_ssh = "rofi -show ssh"
M.dex = "dex --term " .. M.terminal .. " "

local editor = os.getenv("EDITOR") or "nvim"
local editor_cmd = M.terminal .. " -e " .. editor

-- Menubar configuration
menubar.utils.terminal = M.terminal -- Set the terminal for applications that require it

M.myawesomemenu = {
	{
		"hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{ "manual",      M.terminal .. " -e man awesome" },
	{ "edit config", editor_cmd .. " " .. awesome.conffile },
	{ "restart",     awesome.restart },
	{
		"quit",
		function()
			awesome.quit()
		end,
	},
}

M.mainmenu = awful.menu({
	items = {
		{ "awesome",           M.myawesomemenu,                                                             beautiful.awesome_icon },
		{ "open terminal",     M.terminal,                                                                  "/usr/share/icons/Papirus/22x22/apps/gnome-terminal.svg" },
		{ "open browser",      os.getenv("BROWSER"),                                                        "/usr/share/icons/Papirus-Dark/symbolic/places/network-workgroup-symbolic.svg" },
		{ "open file browser", M.dex .. "/usr/share/applications/lf.desktop",                               "/usr/share/icons/Papirus-Dark/symbolic/places/network-workgroup-symbolic.svg" },
		{ "open RSS reader",   M.dex .. os.getenv("HOME") .. "/.local/share/applications/nvimboat.desktop", "/usr/share/icons/Papirus-Dark/symbolic/mimetypes/application-rss+xml-symbolic.svg" },
		{ "select music",      "wimusic select",                                                            "/usr/share/icons/Papirus-Dark/symbolic/mimetypes/audio-x-generic-symbolic.svg" },
	},
})

M.launcher = awful.widget.launcher({
	image = beautiful.awesome_icon,
	menu = M.mainmenu,
})

M.tagnames = {
	console = "󰆍 ",
	browser = "󰈹 ",
	games = " ",
	gameclients = "󰓓 ",
	videos = "󰗃 ",
	art = "󰏘 ",
	docs = "󱉟 ",
	communication = " ",
	download = " ",
}

return M
