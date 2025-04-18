local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")
local menubar = require("menubar")

local control_center_buttons = require("layout.panel.control_center.buttons")
local btn_status = control_center_buttons.status
local btn_controller = control_center_buttons.controller

local apps = require("config.apps")
local mod = require("bindings.mod")
local vars = require("config.vars")
-- local widgets = require 'widgets'

menubar.utils.terminal = apps.terminal

-- general awesome keys
awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { mod.super },
		key = "s",
		description = "show help",
		group = "awesome",
		on_press = hotkeys_popup.show_help,
	}),

	awful.key({
		modifiers = { mod.super },
		key = "w",
		description = "show main menu",
		group = "awesome",
		-- on_press    = function() widgets.mainmenu:show() end,
	}),

	awful.key({
		modifiers = { mod.super, mod.ctrl },
		key = "r",
		description = "reload awesome",
		group = "awesome",
		on_press = awesome.restart,
	}),

	awful.key({
		modifiers = { mod.super },
		key = "Return",
		description = "open a terminal",
		group = "launcher",
		on_press = function()
			awful.spawn(apps.terminal)
		end,
	}),

	awful.key({
		modifiers = { mod.super },
		key = "d",
		description = "open appmenu",
		group = "launcher",
		on_press = function()
			awesome.emit_signal("widget::launcher")
		end,
	}),

	awful.key({
		modifiers = { mod.super, mod.shift },
		key = "c",
		description = "open color picker",
		group = "launcher",
		on_press = function()
			awesome.emit_signal("picker::pick")
		end,
	}),

	awful.key({
		modifiers = { mod.super },
		key = "r",
		description = "open program launcher",
		group = "launcher",
		on_press = function()
			awful.spawn("rofi -show drun")
		end,
	}),
})

-- media related keys
awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = {},
		key = "XF86AudioPlay",
		description = "toggle play/pause media",
		group = "sound",
		on_press = function()
			awful.util.spawn("playerctl play-pause")
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "p",
		description = "toggle play/pause media",
		group = "sound",
		on_press = function()
			awful.util.spawn("playerctl play-pause")
		end,
	}),

	awful.key({
		modifiers = {},
		key = "XF86AudioNext",
		description = "select next media",
		group = "sound",
		on_press = function()
			awful.util.spawn("playerctl next")
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.shift },
		key = "n",
		description = "select next media",
		group = "sound",
		on_press = function()
			awful.util.spawn("playerctl next")
		end,
	}),

	awful.key({
		modifiers = {},
		key = "XF86AudioPrev",
		description = "select previous media",
		group = "sound",
		on_press = function()
			awful.util.spawn("playerctl previous")
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.shift },
		key = "p",
		description = "select previous media",
		group = "sound",
		on_press = function()
			awful.util.spawn("playerctl previous")
		end,
	}),

	awful.key({
		modifiers = {},
		key = "XF86AudioRaiseVolume",
		description = "raise volume by 5%",
		group = "sound",
		on_press = function()
			awful.util.spawn("wpctl set-volume -l 1.2 @DEFAULT_AUDIO_SINK@ 5%+")
			awesome.emit_signal("slider::volume")
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "[",
		description = "raise volume by 5%",
		group = "sound",
		on_press = function()
			awful.util.spawn("wpctl set-volume -l 1.2 @DEFAULT_AUDIO_SINK@ 5%+")
			awesome.emit_signal("slider::volume")
		end,
	}),

	awful.key({
		modifiers = {},
		key = "XF86AudioLowerVolume",
		description = "lower volume by 5%",
		group = "sound",
		on_press = function()
			awful.util.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
			awesome.emit_signal("slider::volume")
		end,
	}),
	awful.key({
		modifiers = { mod.super },
		key = "]",
		description = "lower volume by 5%",
		group = "sound",
		on_press = function()
			awful.util.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
			awesome.emit_signal("slider::volume")
		end,
	}),

	awful.key({
		modifiers = {},
		key = "XF86AudioMute",
		description = "toggle mute/unmute audio",
		group = "sound",
		on_press = function()
			awful.util.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
			btn_status.get_silent_status(function(is_on)
				btn_status.update_button_state(btn_controller.silent, is_on)
			end)
		end,
	}),
	awful.key({
		modifiers = { mod.super, mod.shift },
		key = "m",
		description = "toggle mute/unmute audio",
		group = "sound",
		on_press = function()
			awful.util.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
			btn_status.get_silent_status(function(is_on)
				btn_status.update_button_state(btn_controller.silent, is_on)
			end)
		end,
	}),
})

awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { mod.super, mod.shift },
		key = "s",
		description = "cropped screenshot",
		group = "screenshot",
		on_press = function()
			awesome.emit_signal("screenshot::select")
		end,
	}),

	awful.key({
		modifiers = { mod.super, mod.ctrl },
		key = "s",
		description = "full screenshot",
		group = "screenshot",
		on_press = function()
			awesome.emit_signal("screenshot::full")
		end,
	}),
})

-- tags related keybindings
awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { mod.super },
		key = "Left",
		description = "view previous",
		group = "tag",
		on_press = awful.tag.viewprev,
	}),

	awful.key({
		modifiers = { mod.super },
		key = "Right",
		description = "view next",
		group = "tag",
		on_press = awful.tag.viewnext,
	}),

	awful.key({
		modifiers = { mod.super },
		key = "Escape",
		description = "go back",
		group = "tag",
		on_press = awful.tag.history.restore,
	}),
})

-- focus related keybindings
awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { mod.super },
		key = "j",
		description = "focus next by index",
		group = "client",
		on_press = function()
			awful.client.focus.byidx(1)
		end,
	}),

	awful.key({
		modifiers = { mod.super },
		key = "k",
		description = "focus previous by index",
		group = "client",
		on_press = function()
			awful.client.focus.byidx(-1)
		end,
	}),

	awful.key({
		modifiers = { mod.super },
		key = "Tab",
		description = "go back",
		group = "client",
		on_press = function()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end,
	}),

	awful.key({
		modifiers = { mod.super, mod.ctrl },
		key = "j",
		description = "focus the next screen",
		group = "screen",
		on_press = function()
			awful.screen.focus_relative(1)
		end,
	}),

	awful.key({
		modifiers = { mod.super, mod.ctrl },
		key = "k",
		description = "focus the previous screen",
		group = "screen",
		on_press = function()
			awful.screen.focus_relative(-1)
		end,
	}),

	awful.key({
		modifiers = { mod.super, mod.ctrl },
		key = "n",
		description = "restore minimized",
		group = "client",
		on_press = function()
			local c = awful.client.restore()
			-- Focus restored client
			if c then
				c:emit_signal("request::activate", "key.unminimize", { raise = true })
			end
		end,
	}),
})

-- layout related keybindings
awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { mod.super, mod.shift },
		key = "j",
		description = "swap with next client by index",
		group = "client",
		on_press = function()
			awful.client.swap.byidx(1)
		end,
	}),

	awful.key({
		modifiers = { mod.super, mod.shift },
		key = "k",
		description = "swap with previous client by index",
		group = "client",
		on_press = function()
			awful.client.swap.byidx(-1)
		end,
	}),

	awful.key({
		modifiers = { mod.super },
		key = "u",
		description = "jump to urgent client",
		group = "client",
		on_press = awful.client.urgent.jumpto,
	}),

	awful.key({
		modifiers = { mod.super },
		key = "l",
		description = "increase master width factor",
		group = "layout",
		on_press = function()
			awful.tag.incmwfact(0.05)
		end,
	}),

	awful.key({
		modifiers = { mod.super },
		key = "h",
		description = "decrease master width factor",
		group = "layout",
		on_press = function()
			awful.tag.incmwfact(-0.05)
		end,
	}),

	awful.key({
		modifiers = { mod.super, mod.shift },
		key = "h",
		description = "increase the number of master clients",
		group = "layout",
		on_press = function()
			awful.tag.incnmaster(1, nil, true)
		end,
	}),

	awful.key({
		modifiers = { mod.super, mod.shift },
		key = "l",
		description = "decrease the number of master clients",
		group = "layout",
		on_press = function()
			awful.tag.incnmaster(-1, nil, true)
		end,
	}),

	awful.key({
		modifiers = { mod.super, mod.ctrl },
		key = "h",
		description = "increase the number of columns",
		group = "layout",
		on_press = function()
			awful.tag.incncol(1, nil, true)
		end,
	}),

	awful.key({
		modifiers = { mod.super, mod.ctrl },
		key = "l",
		description = "decrease the number of columns",
		group = "layout",
		on_press = function()
			awful.tag.incncol(-1, nil, true)
		end,
	}),

	awful.key({
		modifiers = { mod.super },
		key = "space",
		description = "select next",
		group = "layout",
		on_press = function()
			awful.layout.inc(1)
		end,
	}),

	awful.key({
		modifiers = { mod.super, mod.shift },
		key = "space",
		description = "select previous",
		group = "layout",
		on_press = function()
			awful.layout.inc(-1)
		end,
	}),
})

awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { mod.super },
		keygroup = "numrow",
		description = "only view tag",
		group = "tag",
		on_press = function(key_num)
			local screen_index = key_num < 6 and 1 or 2
			local tag_index = (key_num - 1) % 5 + 1
			local tag = screen[screen_index].tags[tag_index]
			if tag then
				awful.screen.focus(screen[screen_index])
				tag:view_only()
			end
		end,
	}),

	awful.key({
		modifiers = { mod.super, mod.ctrl },
		keygroup = "numrow",
		description = "toggle tag",
		group = "tag",
		on_press = function(key_num)
			local screen_index = key_num < 6 and 1 or 2
			local tag_index = (key_num - 1) % 5 + 1
			local tag = screen[screen_index].tags[tag_index]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end,
	}),

	awful.key({
		modifiers = { mod.super, mod.shift },
		keygroup = "numrow",
		description = "move focused client to tag",
		group = "tag",
		on_press = function(key_num)
			if client.focus then
				local screen_index = key_num < 6 and 1 or 2
				local tag_index = (key_num - 1) % 5 + 1
				local tag = screen[screen_index].tags[tag_index]
				if tag then
					client.focus:move_to_tag(tag)
					awful.screen.focus(screen[screen_index])
				end
			end
		end,
	}),

	awful.key({
		modifiers = { mod.super, mod.ctrl, mod.shift },
		keygroup = "numrow",
		description = "toggle focused client on tag",
		group = "tag",
		on_press = function(key_num)
			if client.focus then
				local screen_index = key_num < 6 and 1 or 2
				local tag_index = (key_num - 1) % 5 + 1
				local tag = screen[screen_index].tags[tag_index]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end,
	}),

	awful.key({
		modifiers = { mod.super },
		keygroup = "numpad",
		description = "select layout directly",
		group = "layout",
		on_press = function(index)
			local tag = awful.screen.focused().selected_tag
			if tag then
				tag.layout = tag.layouts[index] or tag.layout
			end
		end,
	}),
})

--Keybindings for custom widgets

local function toggle_window(panel_signal, bg_signal, window_name)
	if not vars.open then
		awesome.emit_signal("open::window")
		vars.open = true
	end

	if vars.current_panel ~= window_name then
		awesome.emit_signal(panel_signal)
		awesome.emit_signal(bg_signal)
		vars.current_panel = window_name
	else
		awesome.emit_signal("open::window")
		vars.open = false
		vars.current_panel = "none"
	end
end

awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { mod.super },
		key = "z",
		description = "open panel",
		group = "widgets",
		on_press = function()
			toggle_window("panel::control", "bg::control", "control_center")
		end,
	}),

	awful.key({
		modifiers = { mod.super },
		key = "x",
		description = "open todo",
		group = "widgets",
		on_press = function()
			toggle_window("panel::todo", "bg::todo", "todo")
		end,
	}),

	awful.key({
		modifiers = { mod.super },
		key = "c",
		description = "open calendar",
		group = "widgets",
		on_press = function()
			toggle_window("panel::calendar", "bg::weather", "calendar")
		end,
	}),
})
