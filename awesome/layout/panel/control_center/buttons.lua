local user = require("user")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local color = require("themes.colors")

local img_path = os.getenv("HOME") .. "/.config/awesome/assets/control_center/dark/"

local status = {}

status.update_button_state = function(button, is_on)
	if button then
		button.bg = is_on and color.blue or color.mid_dark
	end
end

status.get_bluetooth_status = function(callback)
	awful.spawn.easy_async_with_shell("bluetoothctl show | grep Powered", function(stdout)
		local is_on = stdout:match("yes") and true or false
		callback(is_on)
	end)
end

status.get_wifi_status = function(callback)
	awful.spawn.easy_async_with_shell("nmcli radio wifi", function(stdout)
		local is_on = stdout:match("enabled") and true or false
		callback(is_on)
	end)
end

status.get_silent_status = function(callback)
	awful.spawn.easy_async_with_shell("wpctl get-volume @DEFAULT_AUDIO_SINK@", function(stdout)
		local is_on = stdout:match("MUTED") and true or false
		callback(is_on)
	end)
end

-- Function to get DND status
status.get_dnd_status = function()
	return naughty.suspended
end

local create_container = function(img, clr, text, fn_on, fn_off)
	local onstatus = false
	local btn = wibox.widget({
		helpers.margin(
			wibox.widget({
				helpers.imagebox(img_path .. img, 35, 35),
				widget = wibox.container.place,
			}),
			20,
			20,
			20,
			20
		),
		widget = wibox.container.background,
		bg = onstatus and clr or color.mid_dark,
		shape = helpers.rrect(50),
	})

	btn:connect_signal("mouse::enter", function()
		local w = mouse.current_wibox
		if w then
			w.cursor = "hand1"
		end
	end)

	btn:connect_signal("mouse::leave", function()
		local w = mouse.current_wibox
		if w then
			w.cursor = "left_ptr"
		end
	end)

	local txt = helpers.textbox(color.lightblue, user.font .. " bold 12", text)
	txt.halign = "center"
	txt.foced_width = dpi(45)

	local container = wibox.widget({
		helpers.margin(btn, 0, 0, 0, 8),
		txt,
		layout = wibox.layout.fixed.vertical,
	})

	btn:connect_signal("button::press", function()
		onstatus = not onstatus
		status.update_button_state(btn, onstatus)
		if onstatus then
			if fn_on then
				fn_on()
			end
		else
			if fn_off then
				fn_off()
			end
		end
	end)

	return helpers.margin(container, 15, 15, 10, 15), btn
end

-- Create buttons (store button widgets)
local buttons = {}
local controller = {}

buttons.wifi, controller.wifi = create_container("wifi.png", color.blue, "WiFi", function()
	awful.spawn("nmcli radio wifi on")
end, function()
	awful.spawn("nmcli radio wifi off")
end)

buttons.bluetooth, controller.bluetooth = create_container("bluetooth.png", color.blue, "Bluetooth", function()
	awful.spawn("bluetoothctl power on")
end, function()
	awful.spawn("bluetoothctl power off")
end)

buttons.silent, controller.silent = create_container("silent.png", color.blue, "Silent", function()
	awful.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ 1")
end, function()
	awful.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0")
end)

buttons.dnd, controller.dnd = create_container("dnd2.png", color.blue, "DND", function()
	naughty.suspended = true
end, function()
	naughty.suspended = false
end)

-- Starting all buttons with false then updating async
status.get_bluetooth_status(function(is_on)
	status.update_button_state(controller.bluetooth, is_on)
end)

status.get_wifi_status(function(is_on)
	status.update_button_state(controller.wifi, is_on)
end)

status.get_silent_status(function(is_on)
	status.update_button_state(controller.silent, is_on)
end)

status.fixed_value = 3

status.update_button_state(controller.dnd, status.get_dnd_status())

-- Panel layout
local main = wibox.widget({
	{
		{
			buttons.wifi,
			buttons.bluetooth,
			buttons.dnd,
			buttons.silent,
			layout = wibox.layout.fixed.horizontal,
		},
		widget = wibox.container.place,
	},
	widget = wibox.container.margin,
	forced_width = dpi(450),
})

return {
	main = main,
	status = status,
	controller = controller,
}
