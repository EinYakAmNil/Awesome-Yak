local awful = require("awful")
local gears = require("gears")
local utils = require("utils")
local wibox = require("wibox")

local scripts = require("scripts")

local M = {}
local idle_text = "no songs playing"
local music_text_widget = wibox.widget.textbox(idle_text)

function M.toggle_song()
	awful.spawn.easy_async(scripts.music .. "toggle", function() end)
end

function M.next_song()
	awful.spawn.easy_async(scripts.music .. "next", function() end)
end

function M.prev_song()
	awful.spawn.easy_async(scripts.music .. "prev", function() end)
end

function M.songs_notify()
	awful.spawn.easy_async(scripts.music .. "notify", function() end)
end

function M.copy_song()
	awful.spawn.easy_async(scripts.music .. "copy", function() end)
end

function M.quit_mpv()
	awful.spawn.easy_async(scripts.music .. "quit", function()
		M:pause()
		M:reset_scrolling()
	end)
end

M = wibox.widget({
	widget = wibox.container.scroll.horizontal,
	max_size = 130,
	extra_space = 20,
	step_function = wibox.container.scroll.step_functions.linear_increase,
	speed = 50,
	fps = 60,
	forced_width = music_text_widget:get_preferred_size(1),
	buttons = gears.table.join(
		awful.button({}, 1, M.songs_notify),
		awful.button({}, 2, M.copy_song),
		awful.button({}, 3, M.toggle_song),
		awful.button({}, 4, M.prev_song),
		awful.button({}, 5, M.next_song)
	),
	{
		widget = music_text_widget,
		ellipsize = "none",
	}
})

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
