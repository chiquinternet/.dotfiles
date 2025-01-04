local awful = require 'awful'
local hotkeys_popup = require 'awful.hotkeys_popup'
require 'awful.hotkeys_popup.keys'
local menubar = require 'menubar'

local apps = require 'config.apps'
local mod = require 'bindings.mod'
local media   = require 'bindings.global.media'
-- local widgets = require 'widgets'

menubar.utils.terminal = apps.terminal

-- general awesome keys
awful.keyboard.append_global_keybindings {
	awful.key {
		modifiers   = { mod.super },
		key         = 's',
		description = 'show help',
		group       = 'awesome',
		on_press    = hotkeys_popup.show_help,
	},

	awful.key {
		modifiers   = { mod.super },
		key         = 'w',
		description = 'show main menu',
		group       = 'awesome',
		-- on_press    = function() widgets.mainmenu:show() end,
	},

	awful.key {
		modifiers   = { mod.super, mod.ctrl },
		key         = 'r',
		description = 'reload awesome',
		group       = 'awesome',
		on_press    = awesome.restart,
	},

	--awful.key {
	--	modifiers   = { mod.super, mod.shift },
	--	key         = 'c',
	--	description = 'quit awesome',
	--	group       = 'awesome',
	--	on_press    = awesome.quit,
	--},

	-- awful.key {
	-- 	modifiers   = { mod.super },
	-- 	key         = 'x',
	-- 	description = 'lua execute prompt',
	-- 	group       = 'awesome',
	-- 	on_press    = function()
	-- 		awful.prompt.run {
	-- 			prompt = 'Run Lua code: ',
	-- 			textbox = awful.screen.focused().promptbox.widget,
	-- 			exe_callback = awful.util.eval,
	-- 			history_path = awful.util.get_cache_dir() .. '/history_eval'
	-- 		}
	-- 	end,
	-- },

	awful.key {
		modifiers   = { mod.super },
		key         = 'Return',
		description = 'open a terminal',
		group       = 'launcher',
		on_press    = function() awful.spawn(apps.terminal) end,
	},

	awful.key {
		modifiers   = { mod.super },
		key         = 'd',
		description = 'open appmenu',
		group       = 'launcher',
		on_press    = function() awesome.emit_signal("widget::launcher") end,
	},

	--awful.key {
	--	modifiers   = { mod.super },
	--	key         = 'p',
	--	description = 'show the menubar',
	--	group       = 'launcher',
	--	on_press    = function() menubar.show() end,
	--},

  awful.key {
    modifiers = { mod.super, mod.shift },
    key = 'c',
    description = "open color picker",
    group = "launcher",
    on_press = function () awesome.emit_signal("picker::pick") end,
  },

  awful.key {
    modifiers = { mod.super },
    key = 'r',
    description = "open program launcher",
    group = "launcher",
    on_press = function ()
      awful.spawn('rofi -show drun')
    end,
  },
}

-- Media related keys
awful.keyboard.append_global_keybindings {
  awful.key {
    modifiers = { },
    key = "XF86AudioPlay",
    description = "toggle play/pause media",
    group = "sound",
    on_press = media.toggle_play,
  },
  awful.key {
    modifiers = { mod.super },
    key = 'p',
    description = "toggle play/pause media",
    group = 'sound',
    on_press = media.toggle_play,
  },

  awful.key {
    modifiers = { },
    key = "XF86AudioNext",
    description = "select next media",
    group = "sound",
    on_press = media.next_track,
  },
  awful.key {
    modifiers = { mod.super, mod.shift },
    key = 'n',
    description = "select next media",
    group = 'sound',
    on_press = media.next_track,
  },

  awful.key {
    modifiers = { },
    key = "XF86AudioPrev",
    description = "select previous media",
    group = "sound",
    on_press = media.previous_track,
  },
  awful.key {
    modifiers = { mod.super, mod.shift },
    key = 'p',
    description = "select previous media",
    group = 'sound',
    on_press = media.previous_track,
  },

  awful.key {
    modifiers = { },
    key = "XF86AudioRaiseVolume",
    description = "raise volume by 5%",
    group = "sound",
    on_press = media.volume_up,
  },
  awful.key {
    modifiers = { mod.super },
    key = '[',
    description = "raise volume by 5%",
    group = 'sound',
    on_press = media.volume_up,
  },

  awful.key {
    modifiers = { },
    key = "XF86AudioLowerVolume",
    description = "lower volume by 5%",
    group = "sound",
    on_press = media.volume_down,
  },
  awful.key {
    modifiers = { mod.super },
    key = ']',
    description = "lower volume by 5%",
    group = 'sound',
    on_press = media.volume_down,
  },

  awful.key {
    modifiers = { },
    key = "XF86AudioMute",
    description = "toggle mute/unmute audio",
    group = "sound",
    on_press = media.toggle_mute,
  },
  awful.key {
    modifiers = { mod.super, mod.shift },
    key = 'm',
    description = "toggle mute/unmute audio",
    group = 'sound',
    on_press = media.toggle_mute,
  },
}

-- tags related keybindings
awful.keyboard.append_global_keybindings {
	awful.key {
		modifiers   = { mod.super },
		key         = 'Left',
		description = 'view previous',
		group       = 'tag',
		on_press    = awful.tag.viewprev,
	},

	awful.key {
		modifiers   = { mod.super },
		key         = 'Right',
		description = 'view next',
		group       = 'tag',
		on_press    = awful.tag.viewnext,
	},

	awful.key {
		modifiers   = { mod.super },
		key         = 'Escape',
		description = 'go back',
		group       = 'tag',
		on_press    = awful.tag.history.restore,
	},
}

-- focus related keybindings
awful.keyboard.append_global_keybindings {
	awful.key {
		modifiers   = { mod.super },
		key         = 'j',
		description = 'focus next by index',
		group       = 'client',
		on_press    = function() awful.client.focus.byidx(1) end,
	},

	awful.key {
		modifiers   = { mod.super },
		key         = 'k',
		description = 'focus previous by index',
		group       = 'client',
		on_press    = function() awful.client.focus.byidx(-1) end,
	},

	awful.key {
		modifiers   = { mod.super },
		key         = 'Tab',
		description = 'go back',
		group       = 'client',
		on_press    = function()
			awful.client.focus.history.previous()
			if client.focus then
				client.focus:raise()
			end
		end,
	},

	awful.key {
		modifiers   = { mod.super, mod.ctrl },
		key         = 'j',
		description = 'focus the next screen',
		group       = 'screen',
		on_press    = function() awful.screen.focus_relative(1) end,
	},

	awful.key {
		modifiers   = { mod.super, mod.ctrl },
		key         = 'k',
		description = 'focus the previous screen',
		group       = 'screen',
		on_press    = function() awful.screen.focus_relative(-1) end,
	},

	awful.key {
		modifiers   = { mod.super, mod.ctrl },
		key         = 'n',
		description = 'restore minimized',
		group       = 'client',
		on_press    = function()
			local c = awful.client.restore()
			if c then
				c:active { raise = true, context = 'key.unminimize' }
			end
		end,
	},
}

-- layout related keybindings
awful.keyboard.append_global_keybindings {
	awful.key {
		modifiers   = { mod.super, mod.shift },
		key         = 'j',
		description = 'swap with next client by index',
		group       = 'client',
		on_press    = function() awful.client.swap.byidx(1) end,
	},

	awful.key {
		modifiers   = { mod.super, mod.shift },
		key         = 'k',
		description = 'swap with previous client by index',
		group       = 'client',
		on_press    = function() awful.client.swap.byidx(-1) end,
	},

	awful.key {
		modifiers   = { mod.super },
		key         = 'u',
		description = 'jump to urgent client',
		group       = 'client',
		on_press    = awful.client.urgent.jumpto,
	},

	awful.key {
		modifiers   = { mod.super },
		key         = 'l',
		description = 'increase master width factor',
		group       = 'layout',
		on_press    = function() awful.tag.incmwfact(0.05) end,
	},

	awful.key {
		modifiers   = { mod.super },
		key         = 'h',
		description = 'decrease master width factor',
		group       = 'layout',
		on_press    = function() awful.tag.incmwfact(-0.05) end,
	},

	awful.key {
		modifiers   = { mod.super, mod.shift },
		key         = 'h',
		description = 'increase the number of master clients',
		group       = 'layout',
		on_press    = function() awful.tag.incnmaster(1, nil, true) end,
	},

	awful.key {
		modifiers   = { mod.super, mod.shift },
		key         = 'l',
		description = 'decrease the number of master clients',
		group       = 'layout',
		on_press    = function() awful.tag.incnmaster(-1, nil, true) end,
	},

	awful.key {
		modifiers   = { mod.super, mod.ctrl },
		key         = 'h',
		description = 'increase the number of columns',
		group       = 'layout',
		on_press    = function() awful.tag.incncol(1, nil, true) end,
	},

	awful.key {
		modifiers   = { mod.super, mod.ctrl },
		key         = 'l',
		description = 'decrease the number of columns',
		group       = 'layout',
		on_press    = function() awful.tag.incncol(-1, nil, true) end,
	},

	awful.key {
		modifiers   = { mod.super },
		key         = 'space',
		description = 'select next',
		group       = 'layout',
		on_press    = function() awful.layout.inc(1) end,
	},

	awful.key {
		modifiers   = { mod.super, mod.shift },
		key         = 'space',
		description = 'select previous',
		group       = 'layout',
		on_press    = function() awful.layout.inc(-1) end,
	},
}

awful.keyboard.append_global_keybindings {
	awful.key {
		modifiers   = { mod.super },
		keygroup    = 'numrow',
		description = 'only view tag',
		group       = 'tag',
		on_press    = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				tag:view_only()
			end
		end
	},

	awful.key {
		modifiers   = { mod.super, mod.ctrl },
		keygroup    = 'numrow',
		description = 'toggle tag',
		group       = 'tag',
		on_press    = function(index)
			local screen = awful.screen.focused()
			local tag = screen.tags[index]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end
	},

	awful.key {
		modifiers   = { mod.super, mod.shift },
		keygroup    = 'numrow',
		description = 'move focused client to tag',
		group       = 'tag',
		on_press    = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end
	},

	awful.key {
		modifiers   = { mod.super, mod.ctrl, mod.shift },
		keygroup    = 'numrow',
		description = 'toggle focused client on tag',
		group       = 'tag',
		on_press    = function(index)
			if client.focus then
				local tag = client.focus.screen.tags[index]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end,
	},

	awful.key {
		modifiers   = { mod.super },
		keygroup    = 'numpad',
		description = 'select layout directly',
		group       = 'layout',
		on_press    = function(index)
			local tag = awful.screen.focused().selected_tag
			if tag then
				tag.layout = tag.layouts[index] or tag.layout
			end
		end
	},
}

--Keybindings for custom widgets
-- Helper function to toggle the window state and manage the current window
local open = false
local current_window = "none"
local function toggle_window(panel_signal, bg_signal, window_name)
    if not open then
        awesome.emit_signal("open::window")
        open = true
    end

    if current_window ~= window_name then
        awesome.emit_signal(panel_signal)
        awesome.emit_signal(bg_signal)
        current_window = window_name
    else
        awesome.emit_signal("open::window")
        open = false
        current_window = "none"
    end
end

awful.keyboard.append_global_keybindings {
    awful.key {
        modifiers = { mod.super },
        key = 'z',
        description = 'open panel',
        group = 'widgets',
        on_press = function()
            toggle_window("panel::control", "bg::control", "control_center")
        end
    },

    awful.key {
        modifiers = { mod.super },
        key = 'x',
        description = 'open todo',
        group = 'widgets',
        on_press = function()
            toggle_window("panel::todo", "bg::todo", "todo")
        end
    },

    awful.key {
        modifiers = { mod.super },
        key = 'c',
        description = 'open calendar',
        group = 'widgets',
        on_press = function()
            toggle_window("panel::calendar", "bg::weather", "calendar")
        end
    },

    --awful.key {
    --    modifiers = { mod.super },
    --    key = 'b',
    --    description = 'open settings',
    --    group = 'widgets',
    --    on_press = function()
    --        toggle_window("panel::settings", "bg::settings", "settings")
    --    end
    --},
}
