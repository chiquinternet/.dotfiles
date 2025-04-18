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
			widget = wibox.container.background,
		})
	end,
})

local current_date = os.date("*t") -- Store current date

local function update_calendar(delta)
	local old_date = calendar_wdgt.date
	local new_date = {
		year = old_date.year,
		month = old_date.month,
	}

	new_date.month = new_date.month + delta
	if new_date.month > 12 then
		new_date.month = 1
		new_date.year = new_date.year + 1
	elseif new_date.month < 1 then
		new_date.month = 12
		new_date.year = new_date.year - 1
	end

	if new_date.month == current_date.month then
		new_date.day = current_date.day
	else
		new_date.day = nil
	end

	calendar_wdgt.date = new_date
end

local function reset_calendar()
	calendar_wdgt.date = current_date
end

calendar_wdgt:buttons(awful.util.table.join(
	awful.button({}, 4, function()
		update_calendar(-1)
	end),
	awful.button({}, 5, function()
		update_calendar(1)
	end),
	awful.button({}, 1, function()
		reset_calendar()
	end)
))

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
		forced_height = dpi(355),
	},
	widget = wibox.container.margin,
	margins = dpi(10),
})

return wgt
