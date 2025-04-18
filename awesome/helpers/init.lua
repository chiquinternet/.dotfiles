local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi

local helpers = {}

---Shapes------------------------
---------------------------------
helpers.rrect = function(radius)
	return function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, radius)
	end
end

helpers.part_rrect = function(tl, tr, br, bl, radius)
	return function(cr, width, height)
		gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
	end
end

helpers.rbar = function(rad_x, rad_y)
	return function(cr, width, height)
		gears.shape.rounded_bar(cr, dpi(rad_x), dpi(rad_y))
	end
end

---Markup-------------------------
----------------------------------
helpers.mtext = function(color, font, text)
	return '<span color="' .. color .. '" font="' .. font .. '">' .. text .. "</span>"
end

---widgets------------------------
----------------------------------
function helpers.textbox(color, font, text)
	local widget = wibox.widget.textbox()

	-- Store formatting properties
	widget._text_format = { color = color, font = font }

	-- Function to set text and reapply formatting
	function widget:set_text(new_text)
		-- Reapply the formatting via markup
		local formatted_text = string.format(
			'<span color="%s" font="%s">%s</span>',
			self._text_format.color,
			self._text_format.font,
			new_text
		)
		-- Use set_markup to set both the style and the text
		wibox.widget.textbox.set_markup(self, formatted_text)
	end

	-- Set the initial text with formatting
	widget:set_text(text)

	return widget
end

helpers.imagebox = function(img, height, width)
	return wibox.widget({
		image = img,
		resize = true,
		forced_height = dpi(height),
		forced_width = dpi(width),
		widget = wibox.widget.imagebox,
	})
end

helpers.margin = function(wgt, ml, mr, mt, mb)
	return wibox.widget({
		wgt,
		widget = wibox.container.margin,
		left = dpi(ml),
		right = dpi(mr),
		top = dpi(mt),
		bottom = dpi(mb),
	})
end

---Hover_effects---------------------
-------------------------------------
helpers.add_hover_effect = function(button, clr_hvr, clr_press, clr_nrml)
	button:connect_signal("mouse::enter", function()
		button.bg = clr_hvr
	end)

	button:connect_signal("mouse::leave", function()
		button.bg = clr_nrml
	end)

	button:connect_signal("button::press", function()
		button.bg = clr_press
	end)

	button:connect_signal("button::release", function()
		button.bg = clr_hvr
	end)
end

return helpers
