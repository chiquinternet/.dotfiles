local awful = require 'awful'
local menu = require 'popups.menu'
local vars = require 'config.vars'

awful.mouse.append_global_mousebindings {
  --awful.button {
  --  modifiers = {},
  --  button = 1,
  --  on_press = function()
  --    if mouse.coords().x > 450 and vars.open then
  --      awesome.emit_signal("open::window")
  --      vars.open = false
  --      vars.current_panel = "none"
  --    end
  --  end
  --},
  awful.button {
    modifiers = {},
    button    = 3,
    on_press  = function() menu:toggle() end
  },
  awful.button {
    modifiers = {},
    button    = 4,
    on_press  = awful.tag.viewprev
  },
  awful.button {
    modifiers = {},
    button    = 5,
    on_press  = awful.tag.viewnext
  },
}
