local awful = require("awful")
local wibox = require("wibox")
local M = {}

local margin = 5

local bar_pos = screen[1].mywibox:geometry()
local contain = wibox.widget({
	{
		widget = wibox.widget.calendar.month,
		date = os.date("*t"),
		font = "Ubuntu 14",
	},
	widget = wibox.container.margin,
	margins = 10,
})

M.pop = awful.popup({
	widget = contain,
	x = bar_pos["width"],
	y = bar_pos["y"] + bar_pos["height"] + margin,
})
M.pop:connect_signal("property::width", function()
	print(M.pop.width)
	M.pop.x = M.pop.x - M.pop.width - margin
end)

return M
