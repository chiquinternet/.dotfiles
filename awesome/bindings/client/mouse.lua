local awful = require'awful'
local mod = require'bindings.mod'
local vars = require 'config.vars'

awful.mouse.append_client_mousebindings{
  --awful.button {
  --  modifiers = {},
  --  button = 2,
  --  on_press = function()
  --    if mouse.coords().x > 451 and vars.open then
  --      awesome.emit_signal("open::window")
  --      vars.open = false
  --      vars.current_panel = "none"
  --    end
  --  end
  --},
  awful.button{
    modifiers = {},
    button    = 1,
    on_press  = function(c) c:activate{context = 'mouse_click'} end
  },
  awful.button{
    modifiers = {mod.super},
    button    = 1,
    on_press  = function(c) c:activate{context = 'mouse_click', action = 'mouse_move'} end
  },
  awful.button{
    modifiers = {mod.super},
    button    = 3,
    on_press  = function(c) c:activate{context = 'mouse_click', action = 'mouse_resize'} end
  },
}
