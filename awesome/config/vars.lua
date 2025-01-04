local _M = {}

local awful = require 'awful'

_M.layouts = {
 awful.layout.suit.tile,
 awful.layout.suit.tile.left,
 awful.layout.suit.tile.bottom,
 awful.layout.suit.tile.top,
 awful.layout.suit.fair,
 awful.layout.suit.fair.horizontal,
 awful.layout.suit.spiral,
 awful.layout.suit.spiral.dwindle,
 awful.layout.suit.max,
 awful.layout.suit.max.fullscreen,
 awful.layout.suit.magnifier,
 awful.layout.suit.corner.nw,
 awful.layout.suit.floating,
}

_M.open = false
_M.current_panel = "none"

return _M
