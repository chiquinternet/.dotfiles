local user = require("user")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("helpers")
local colors = require("themes.colors")

local dpi = beautiful.xresources.apply_dpi

-- Function to create a slider widget (volume or brightness)
local function create_slider_widget(command, icon_code, initial_value, max_value)
	-- Create the slider widget
	local slider = wibox.widget({
		widget = wibox.widget.slider,
		bar_shape = helpers.rrect(0),
		bar_height = dpi(8),
		bar_color = colors.mid_dark,
		bar_active_color = colors.blue,
		handle_shape = gears.shape.circle,
		handle_color = colors.lightblue,
		handle_width = dpi(25),
		handle_border_width = 3,
		handle_border_color = colors.bg_dim,
		minimum = 0,
		maximum = max_value or 100, -- default max value
		value = initial_value or 50, -- default initial value
	})

	local value_tooltip = awful.tooltip({
		mode = "mouse",
		align = "top_left",
		bg = colors.bg_normal,
		fg = colors.mid_light,
		font = user.font .. " bold 13",
	})

	value_tooltip:add_to_object(slider)

	-- Set the value when the slider is moved
	slider:connect_signal("property::value", function(slider)
		local level = math.floor(slider.value / 100 * max_value)
		awful.spawn(command .. " " .. level .. "%")
		value_tooltip.text = tostring(slider.value)
	end)

	-- Icon for the slider
	local icon = helpers.margin(helpers.textbox(colors.orange, "Ubuntu Nerd Font bold 30", icon_code), 0, 15, 5, 5)

	-- Final widget layout with icon, slider, and value display
	local final_widget = wibox.widget({
		{
			icon,
			slider,
			layout = wibox.layout.align.horizontal,
		},
		widget = wibox.container.margin,
		forced_height = dpi(50),
		forced_width = dpi(250),
	})

	return final_widget, slider, value_tooltip
end

-- Create a brightness slider
local brightness_widget, brightness_slider, brightness_tooltip =
	create_slider_widget("brightnessctl set", "󰃠", 100, 100)

-- Create a volume slider
local volume_widget, volume_slider, volume_tooltip =
	create_slider_widget("wpctl set-volume -l 1.2 @DEFAULT_AUDIO_SINK@", "󰕾", 65, 100)

awesome.connect_signal("slider::brightness", function()
	awful.spawn.easy_async_with_shell("brightnessctl", function(stdout)
		-- Parse the brightness value and set the slider
		local brightness = tonumber(stdout:match("([%d%.]+)%%"))
		if brightness then
			brightness_slider.value = brightness
			brightness_tooltip.text = tostring(brightness)
		end
	end)
end)

awesome.connect_signal("slider::volume", function()
	awful.spawn.easy_async_with_shell("wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f 2", function(stdout)
		-- Parse the volume value and set the slider
		local volume = tonumber(stdout:match("([%d%.]+)")) * 100
		if volume then
			volume_slider.value = volume
			volume_tooltip.text = tostring(math.floor(volume))
		end
	end)
end)

awesome.emit_signal("slider::volume")
awesome.emit_signal("slider::brightness")

-- Final layout to display both sliders
local sys = wibox.widget({
	{
		brightness_widget,
		volume_widget,
		layout = wibox.layout.fixed.vertical,
	},
	widget = wibox.container.margin,
	margins = dpi(10),
})

return sys
