local user = require("user")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local colors = require("themes.colors")

local calendar_wdgt = wibox.widget({
	widget = wibox.widget.calendar.month,
	date = os.date("*t"),
	font = user.font .. " bold 15",
	flex_height = true,
	start_sunday = true,
	fn_embed = function(widget, flag, date)
		local focus_widget = wibox.widget({
			text = date.day,
			align = "center",
			widget = wibox.widget.textbox,
			font = user.font .. " bold 15",
		})
		local torender = flag == "focus" and focus_widget or widget
		if flag == "header" then
			torender.font = user.font .. " bold " .. 15
		end
		if flag == "weekday" then
			torender.font = user.font .. " bold " .. 15
		end

		local color_list = {
			header = colors.lightblue,
			focus = colors.orange,
			normal = colors.fg_normal,
			weekday = colors.magenta,
		}
		local color = color_list[flag] or beautiful.fg_normal
		return wibox.widget({

			{
				{
					torender,
					align = "left",
					widget = wibox.container.place,
				},
				margins = dpi(7),
				widget = wibox.container.margin,
			},
			fg = color,
			bg = colors.bg_normal,
			shape = helpers.rrect(0),
			-- forced_hight = dpi(300),
			widget = wibox.container.background,
		})
	end,
})

local wgt = wibox.widget({
	{
		{
			calendar_wdgt,
			widget = wibox.container.margin,
			margins = dpi(10),
		},
		widget = wibox.container.background,
		bg = colors.bg_normal,
		shape = helpers.rrect(0),
	},
	widget = wibox.container.margin,
	margins = dpi(10),
})

return wgt
