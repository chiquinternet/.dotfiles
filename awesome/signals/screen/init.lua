local awful = require ("awful")
local beautiful = require ("beautiful")
local gears = require ("gears")

-- Set wallpaper for a screen
local function set_wallpaper (s)
  if beautiful.wallpaper then
    local wallpaper = type (beautiful.wallpaper) == "function"
        and beautiful.wallpaper (s)
      or beautiful.wallpaper
    gears.wallpaper.maximized (wallpaper, s, true)
  end
end

-- Update wallpaper when screen geometry changes
screen.connect_signal ("property::geometry", set_wallpaper)

-- Screen setup
awful.screen.connect_for_each_screen (function (s)
  set_wallpaper (s)

  -- Define tag layouts for different screens
  local suit = awful.layout.suit
  local tags_by_screen = {
    [1] = {
      { name = "1", layout = suit.floating, selected = true },
      { name = "2", layout = suit.tile.left, master_width_factor = 0.75 },
      { name = "3", layout = suit.tile },
      { name = "4", layout = suit.floating },
      { name = "5", layout = suit.tile, master_width_factor = 0.55 },
    },
    [2] = {
      { name = "6", layout = suit.tile },
      { name = "7", layout = suit.tile },
    },
  }
                             
  -- Apply tags based on screen index
  if tags_by_screen[s.index] then
    for _, tag_def in ipairs (tags_by_screen[s.index]) do
      awful.tag.add (tag_def.name, {
        layout = tag_def.layout,
        master_fill_policy = "expand",
        master_width_factor = tag_def.master_width_factor,
        screen = s,
        selected = tag_def.selected or false,
      })
    end
  end
end)
