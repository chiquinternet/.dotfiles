local awful = require 'awful'
local ruled = require 'ruled'

local borderlessClasses = {
  ["org.gnome.Nautilus"] = true,
  ["pentablet"] = true,
  ["vesktop"] = true,
}

ruled.client.connect_signal('request::rules', function()
  -- All clients will match this rule.
  ruled.client.append_rule {
    id         = 'global',
    rule       = {},
    properties = {
      focus     = awful.client.focus.filter,
      raise     = true,
      screen    = awful.screen.preferred,
      placement = awful.placement.centered + awful.placement.no_overlap + awful.placement.no_offscreen
    }
  }

  -- Floating clients.
  ruled.client.append_rule {
    id = 'floating',
    rule_any = {
      instance = { 'copyq', 'pinentry' },
      class = {
        'Arandr',
        'Blueman-manager',
        'Gpick',
        'Kruler',
        'Sxiv',
        'Tor Browser',
        'Wpa_gui',
        'veromix',
        'xtightvncviewer',
      },
      -- Note that the name property shown in xprop might be set slightly after creation of the client
      -- and the name shown there might not match defined rules here.
      name = {
        'Event Tester',     -- xev.
      },
      role = {
        'AlarmWindow',       -- Thunderbird's calendar.
        'ConfigManager',     -- Thunderbird's about:config.
        'pop-up',            -- e.g. Google Chrome's (detached) Developer Tools.
      }
    },
    properties = { floating = true }
  }
  -- Add titlebars to normal clients and dialogs
  ruled.client.append_rule {
    id         = 'titlebars',
    rule_any   = { type = { 'normal', 'dialog' } },
    properties = { titlebars_enabled = false },
  }

  -- Custom rules 
  ruled.client.append_rule {
    rule = {class = 'firefox'},
    properties = {tag = "3"}
  }
  ruled.client.append_rule {
    rule = { class = "[Ss]potify" },
    properties = { tag = "4" }
  }
  ruled.client.append_rule {
    rule = { class = "Blueman-manager" },
    properties = { tag = "4" }
  }
  ruled.client.append_rule {
    rule = { class = "[Pp]avucontrol" },
    properties = { tag = "4" }
  }
  ruled.client.append_rule {
    rule = { class = "[Dd]iscord" },
    properties = { tag = "3" }
  }
  ruled.client.append_rule {
    rule = { class = "vesktop" },
    properties = { tag = "3", titlebars_enabled = false, }
  }
  ruled.client.append_rule {
    rule = { class = "vesktop" },
    properties = { tag = "3" }
  }
  ruled.client.append_rule {
    rule = { class = "krita" },
    properties = { tag = "2" }
  }
  ruled.client.append_rule {
    rule = { class = "PureRef" },
    properties = { tag = "2" }
  }
  ruled.client.append_rule {
    rule = { instance = "Godot_Engine" },
    properties = { floating = true }
  }
  ruled.client.append_rule {
    rule = { instance = "org.gnome.Nautilus" },
    properties = { titlebars_enabled = false, }
  }
  ruled.client.append_rule {
    rule = { instance = "PenTablet" },
    properties = { titlebars_enabled = false, }
  }
  client.connect_signal("manage", function(c)
    if borderlessClasses[c.class] then
        c.border_width = 0
    end
  end)

end)
