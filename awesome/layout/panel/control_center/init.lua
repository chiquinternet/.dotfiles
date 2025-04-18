local wibox = require('wibox')
local beautiful = require('beautiful')

local header = require('layout.panel.control_center.header')
local buttons = require('layout.panel.control_center.buttons')
local sliders = require('layout.panel.control_center.sliders')
local notif_center = require('layout.panel.control_center.notif_center')
local media_player = require('layout.panel.control_center.media_player')

local cc = wibox.widget {
	header,
	buttons.main,
	sliders,
  media_player,
	notif_center,
	layout = wibox.layout.fixed.vertical,
}

return cc
