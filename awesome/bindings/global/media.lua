local awful = require ("awful")
local _M = {}

-- Define your media control functions
_M.toggle_play = function ()
  awful.util.spawn ("playerctl play-pause")
end

_M.next_track = function ()
  awful.util.spawn ("playerctl next")
end

_M.previous_track = function ()
  awful.util.spawn ("playerctl previous")
end

_M.volume_up = function ()
  awful.util.spawn ("wpctl set-volume -l 1.2 @DEFAULT_AUDIO_SINK@ 5%+")
end

_M.volume_down = function ()
  awful.util.spawn ("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
end

_M.toggle_mute = function ()
  awful.util.spawn ("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
end

return _M
