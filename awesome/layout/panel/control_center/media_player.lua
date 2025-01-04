local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local dpi = beautiful.xresources.apply_dpi
local gears = require('gears')

local helpers = require('helpers')
local color = require('themes.colors')
local bling = require('modules.bling')

--Album art
local art = helpers.imagebox(os.getenv("HOME") .. "/.config/awesome/assets/control_center/music.svg", 60, 60)
art.halign = 'center'
art.valign = 'center'

--Title
local title_widget = helpers.textbox(color.lightblue, "IosevkaTermNF bold 15", "Nothing playing")
title_widget.forced_width = dpi(250)
title_widget.forced_height = dpi(35)
title_widget.halign = 'center'

--Artist
local artist_widget = helpers.textbox(color.mid_light, "IosevkaTermNF 13", "Unknown artist")
artist_widget.forced_width = dpi(250)
artist_widget.forced_height = dpi(35)
artist_widget.halign = 'center'

-- Update image, title, channel
local playerctl = bling.signal.playerctl.lib{
  playerctl_update_on_activity = true
}

playerctl:connect_signal("metadata",
function(_, title, artist, album_path, album, new, player_name)
  art:set_image(gears.surface.load_uncached(album_path))
  title_widget:set_markup_silently(helpers.mtext(color.lightblue, "IosevkaTermNF bold 14", title))
  artist_widget:set_markup_silently(helpers.mtext(color.mid_light, "IosevkaTermNF 13", artist))
end)

-----------------------------
--Position Slider------------
-----------------------------
local media_slider = wibox.widget {
  widget = wibox.widget.slider,
  bar_shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 0)
  end,
  bar_height = dpi(8),
  bar_color = color.mid_dark,
  bar_active_color = color.blue,
  handle_shape = gears.shape.circle,
  handle_color = color.lightblue,
  handle_width = dpi(15),
  handle_border_width = 0,
  handle_border_color = "#4682b8",
  minimum = 0,
  maximum = 100,
  value = 69,
  forced_height = dpi(20)
}

--Update slider value
local previous_value = 0
local internal_update = false

media_slider:connect_signal("property::value", function(_, new_value)
  if internal_update and new_value ~= previous_value then
    playerctl:set_position(new_value)
    previous_value = new_value
  end
end)

playerctl:connect_signal("position", function(_, interval_sec, length_sec)
  awful.spawn.easy_async("playerctl status", function(status)
    if status:match("^%s*Playing%s*$") then
      internal_update = true
      previous_value = interval_sec
      media_slider.value = interval_sec
      media_slider.maximum = length_sec
    end
  end)
end)

  --Position/length text
  local length_text = wibox.widget {
    markup = helpers.mtext(color.mid_light, "IosevkaTermNF bold 11", "00:00"),
    valign = 'top',
    widget = wibox.widget.textbox,
    forced_height = dpi(15),
    halign = "left"
  }

  local position_text = wibox.widget {
    markup = helpers.mtext(color.mid_light, "IosevkaTermNF bold 11", "00:00"),
    align = 'center',
    valign = 'top',
    widget = wibox.widget.textbox,
    forced_height = dpi(15),
    halign = "left"
  }

  --Update media length---
  local update_length_text = function()
    awful.spawn.easy_async("playerctl metadata -f '{{mpris:length}}'", function(stdout)
      if stdout == "" then
        local text = '00:00'
        length_text:set_markup_silently(helpers.mtext(color.mid_light, "IosevkaTermNF bold 11", text))
      elseif stdout == nil then
        local length = 0
        local minutes = math.floor(length / 60)
        local formattedminutes = string.format("%02d", minutes)
        local seconds = math.floor(length % 60)
        local formattedseconds = string.format("%02d", seconds)
        length_text:set_markup_silently(
        helpers.mtext(color.mid_light, "IosevkaTermNF bold 11", formattedminutes .. ':' .. formattedseconds)
        )
      else
        if tonumber(stdout) ~= nil then
          local length = tonumber(stdout) / 1000000
          local minutes = math.floor(length / 60)
          local formattedminutes = string.format("%02d", minutes)
          local seconds = math.floor(length % 60)
          local formattedseconds = string.format("%02d", seconds)
          length_text:set_markup_silently(
          helpers.mtext(color.mid_light, "IosevkaTermNF bold 11", formattedminutes .. ':' .. formattedseconds)
          )
        end
      end
    end)
  end

  local update_length_text_timer = gears.timer({
    timeout = 0.3,
    call_now = true,
    autostart = true,
    callback = update_length_text,
  })

  --Update media position
  local update_position_text = function()
    awful.spawn.easy_async("playerctl status", function(status)
      if status:match("^%s*Playing%s*$") then
        awful.spawn.easy_async("playerctl position", function(stdout)
          local length = tonumber(stdout)
          if length then
            local minutes = math.floor(length / 60)
            local formattedminutes = string.format("%02d", minutes)
            local seconds = math.floor(length % 60)
            local formattedseconds = string.format("%02d", seconds)
            position_text:set_markup_silently(
            helpers.mtext(color.mid_light, "IosevkaTermNF bold 11", formattedminutes .. ':' .. formattedseconds)
            )
          else
            local text = '00:00'
            position_text:set_markup_silently(helpers.mtext(color.mid_light, "IosevkaTermNF bold 11", text))
          end
        end)
      end
    end)
  end

  local update_position_text_timer = gears.timer({
    timeout = 0.2,
    call_now = true,
    autostart = true,
    callback = update_position_text,
  })

  -- Update state
  ------------------------------
  --Buttons---------------------
  ------------------------------

  local play_pause = helpers.textbox(color.blue, "Ubuntu Nerd Font bold 17", "")
  local forward = helpers.textbox(color.purple, "Ubuntu Nerd Font bold 17", "")
  local backward = helpers.textbox(color.purple, "Ubuntu Nerd Font bold 17", "")
  local f15 = helpers.textbox(color.green, "Ubuntu Nerd Font bold 17", "󱤺")
  local b15 = helpers.textbox(color.green, "Ubuntu Nerd Font bold 17", "󱥆")

  local create_container = function(wgt)
    local btn = helpers.margin(
    wibox.widget {
      wgt,
      widget = wibox.container.place
    },
    8, 8, 8, 8
    )

    btn.forced_height = dpi(45)
    btn.forced_width = dpi(45)

    local container = wibox.widget {
      btn,
      widget = wibox.container.background,
      bg = color.bg_dark,
      border_width = 3,
      border_color = color.bg_dark .. "80",
      shape = helpers.rrect(45)
    }

    return helpers.margin(container, 8, 8, 0, 0)
  end

  local play_pause_btn = create_container(play_pause)
  local forward_btn = create_container(forward)
  local backward_btn = create_container(backward)
  local f15_btn = create_container(f15)
  local b15_btn = create_container(b15)

  --Button functionality
  local is_playing = true
  play_pause_btn:connect_signal("button::release", function()
    is_playing = not is_playing
    if is_playing then
      awful.spawn('playerctl play')
    else
      awful.spawn('playerctl pause')
    end
  end)

  local update_state = function()
    awful.spawn.easy_async("playerctl status", function(stdout)
      if stdout:match("Paused") then
        is_playing = false
        play_pause.markup = helpers.mtext(color.blue, "Ubuntu Nerd Font bold 17", '')
      else
        is_playing = true
        play_pause.markup = helpers.mtext(color.blue, "Ubuntu Nerd Font bold 17", '')
      end
    end)
  end

  local update_state_timer = gears.timer({
    timeout = 0.2,
    call_now = true,
    autostart = true,
    callback = update_state,
  })

  forward_btn:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then
      awful.spawn.with_shell("playerctl next")
    end
  end)

  backward_btn:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then
      awful.spawn.with_shell("playerctl previous")
    end
  end)

  f15_btn:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then
      awful.spawn.with_shell("playerctl position 15+")
    end
  end)

  b15_btn:connect_signal("button::press", function(_, _, _, button)
    if button == 1 then
      awful.spawn.with_shell("playerctl position 15-")
    end
  end)

  local mplayer_widget = wibox.widget {
    {
      {
        {
          -- Album art on the left
          helpers.margin(art, 0, 15, 0, 0),
          -- Title and artist stacked vertically
          {
            title_widget,
            artist_widget,
            layout = wibox.layout.fixed.vertical
          },
          layout = wibox.layout.align.horizontal
        },
        helpers.margin(media_slider, 0, 0, 10, 10),
        helpers.margin({ position_text, nil, length_text, layout = wibox.layout.align.horizontal }, 0, 0, 0, 20),
        {
          {
            b15_btn,
            backward_btn,
            play_pause_btn,
            forward_btn,
            f15_btn,
            layout = wibox.layout.fixed.horizontal
          },
          widget = wibox.container.place
        },
        layout = wibox.layout.fixed.vertical
      },
      widget = wibox.container.margin,
      margins = dpi(25),
      forced_width = dpi(350)
    },
    widget = wibox.container.background,
    bg = color.bg_normal,
    shape = helpers.rrect(15)
  }

  return helpers.margin(mplayer_widget, 10, 10, 30, 10)
