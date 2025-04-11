local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local defaults = require("defaults")
local M = {}

local bar_pos = screen[1].statusbar:geometry()
local calendar_widget = wibox.widget({
	{
		{
			widget = wibox.widget.calendar.month,
			date = os.date("*t"),
			font = "Ubuntu 14",
		},
		{
			widget = wibox.widget.calendar.month,
			date = (function()
				local date = os.date("*t")
				return {
					month = date["month"] + 1,
					year = date["year"],
				}
			end)(),
			font = "Ubuntu 14",
		},
		layout = wibox.layout.fixed.vertical,
	},
	widget = wibox.container.margin,
	margins = defaults.margin,
})

M.calendar = awful.popup({
	widget = calendar_widget,
	x = bar_pos["width"],
	y = bar_pos["y"] + bar_pos["height"] + defaults.margin,
})

awful.spawn.easy_async(defaults.scripts_path .. "disk-use.sh", function(stdout)
	local partitions = {}
	local lines = gears.string.split(stdout, "\n")
	for i, l in ipairs(lines) do
		if l ~= "" then
			local vals = gears.string.split(l, " ")
			partitions[i] = {
				source = vals[1],
				target = vals[2],
				pcent = vals[3],
				avail = vals[4],
			}
			local pie_description = wibox.widget({
				widget = wibox.widget.textbox,
				text = vals[1] .. "  " .. vals[2],
			})

			M.disk_use = awful.popup({
				widget = {
					{
						pie_description,
						{
							widget = wibox.container.constraint,
							strategy = "max",
							width = pie_description:get_preferred_size(),
							height = pie_description:get_preferred_size(),
							{
								widget = wibox.widget.piechart,
								data_list = (function()
									local used = tonumber(string.sub(vals[3], 1, -2))
									return {
										{ "used", used },
										{ "free", 100 - used },
									}
								end)(),
								colors = {
									"#ff0000",
									"#00ff00",
								},
								display_labels = false,
								forced_width = 500,
								forced_height = 500
							},
						},
						layout = wibox.layout.fixed.vertical,
					},
					widget = wibox.container.margin,
					margins = defaults.margin,
				},
				x = math.floor(math.random() * 1000),
				y = math.floor(math.random() * 500),
			})

			M.disk_use:connect_signal("property::width", function()
				M.disk_use.x = bar_pos["width"] - M.disk_use.width - defaults.margin
				M.disk_use.y = M.calendar.y + M.calendar.height + defaults.margin
			end)
		end
	end
end)

M.calendar:connect_signal("property::width", function()
	M.calendar.x = M.calendar.x - M.calendar.width - defaults.margin
end)

return M
