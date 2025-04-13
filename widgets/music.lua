local awful = require("awful")
local gears = require("gears")
local utils = require("utils")
local wibox = require("wibox")

local scripts = require("scripts")

local idle_text = "no songs playing"
local music_text_widget = wibox.widget.textbox(idle_text)

local function toggle_song()
	awful.spawn.easy_async(scripts.music .. "toggle", function() end)
end

local function next_song()
	awful.spawn.easy_async(scripts.music .. "next", function() end)
end

local function prev_song()
	awful.spawn.easy_async(scripts.music .. "prev", function() end)
end

local function songs_notify()
	awful.spawn.easy_async(scripts.music .. "notify", function() end)
end

local function copy_song()
	awful.spawn.easy_async(scripts.music .. "copy", function() end)
end

local function quit_mpv()
	awful.spawn.easy_async(scripts.music .. "quit", function() end)
end

local M = wibox.widget({
	widget = wibox.container.scroll.horizontal,
	max_size = 130,
	extra_space = 20,
	step_function = wibox.container.scroll.step_functions.linear_increase,
	speed = 50,
	fps = 60,
	forced_width = music_text_widget:get_preferred_size(1),
	buttons = gears.table.join(
		awful.button({}, 1, songs_notify),
		awful.button({}, 2, copy_song),
		awful.button({}, 3, toggle_song),
		awful.button({}, 4, prev_song),
		awful.button({}, 5, next_song)
	),
	{
		widget = music_text_widget,
		ellipsize = "none",
	}
})

function M.toggle_song()
	toggle_song()
end

function M.next_song()
	next_song()
end

function M.prev_song()
	prev_song()
end

function M.songs_notify()
	songs_notify()
end

function M.copy_song()
	copy_song()
end

function M.quit_mpv()
	quit_mpv()
end

function M.get_song()
	awful.spawn.easy_async(scripts.music .. "status", function(stdout, stderr, _, exit_code)
		if stderr ~= "" and exit_code ~= 0 then
			utils.debug(stderr)
		end
		if #stdout > 1 then
			music_text_widget.text = "𝅘𝅥𝅮♪  " .. stdout
			M:continue()
		else
			music_text_widget.text = idle_text
			M:pause()
			M:reset_scrolling()
		end
	end)
end

M.get_song()

return M
