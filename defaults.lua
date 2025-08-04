local awful = require("awful")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local menubar = require("menubar")
local gears = require("gears")

M = {}
M.modkey = "Mod4"

M.terminal = os.getenv("TERM") or "kitty"

local dex = "dex --term " .. M.terminal .. " "

M.rofi_desktop = "rofi -terminal " .. M.terminal .. " -show drun"
M.rofi_ssh = "rofi -show ssh"
M.nvimboat = dex .. os.getenv("HOME") .. "/.local/share/applications/nvimboat.desktop"
M.lf = dex .. "/usr/share/applications/lf.desktop"
M.rofi_music = 'rofi -modes "music:rofi-music,playlist:rofi-playlist" -show music'

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
		{ "awesome",           M.myawesomemenu,      beautiful.awesome_icon },
		{ "open terminal",     M.terminal,           "/usr/share/icons/Papirus/22x22/apps/gnome-terminal.svg" },
		{ "open browser",      os.getenv("BROWSER"), "/usr/share/icons/Arc/places/symbolic/network-workgroup-symbolic.svg" },
		{ "open file browser", M.lf,                 "/usr/share/icons/Arc/mimetypes/symbolic/inode-directory-symbolic.svg" },
		{ "open RSS reader",   M.nvimboat,           "/usr/share/icons/Arc/mimetypes/symbolic/application-rss+xml-symbolic.svg" },
		{ "select music",      M.rofi_music,         "/usr/share/icons/Arc/mimetypes/symbolic/audio-x-generic-symbolic.svg" },
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

M.margin = 8

M.scripts_path = gears.filesystem.get_xdg_config_home() .. "awesome/scripts/"

return M
