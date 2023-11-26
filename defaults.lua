local awful = require("awful")
local beautiful = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local menubar = require("menubar")
-- local theme = 
-- Define defaults used by all modules here

-- This is used later as the default terminal and editor to run.
-- }}}
M = {}

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
M.modkey = "Mod4"

M.terminal = os.getenv("TERM") or "alacritty"
-- M.dmenu_desktop = 'j4-dmenu-desktop --term alacritty --dmenu="dmenu -i -fn Ubuntu\\ Mono:size=22"'
M.rofi_desktop = "rofi -show drun"
M.rofi_ssh = "rofi -show ssh"

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
	{ "manual", M.terminal .. " -e man awesome" },
	{ "edit config", editor_cmd .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{
		"quit",
		function()
			awesome.quit()
		end,
	},
}

M.mainmenu = awful.menu({
	items = {
		{ "awesome", M.myawesomemenu, beautiful.awesome_icon },
		{ "open terminal", M.terminal, "/usr/share/icons/Papirus/22x22/apps/gnome-terminal.svg" },
		{ "select music", "musictl select", "/usr/share/icons/Papirus-Dark/symbolic/mimetypes/audio-x-generic-symbolic.svg" },
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
	trash = " ",
}

return M
