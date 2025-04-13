local awful = require("awful")

local M = {}
local scripts_dir = awful.util.get_configuration_dir() .. "scripts/"

M.disk_use = scripts_dir .. "disk-use.sh "
M.music = scripts_dir .. "music "
M.volume = scripts_dir .. "volume "

return M
