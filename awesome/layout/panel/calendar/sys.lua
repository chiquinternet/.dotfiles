local beautiful = require ("beautiful")
local colors = require ("themes.colors")
local helpers = require ("helpers")
local wibox = require ("wibox")
local awful = require ("awful")
local gears = require ("gears")
local user = require ("user")
local dpi = beautiful.xresources.apply_dpi

-- Function to create a progress bar with label
local function create_progress_widget (name, color)
  local controller = {}

  controller.progress_bar = wibox.widget ({
    max_value = 100,
    value = 0,
    widget = wibox.widget.progressbar,
    forced_width = 250,
    forced_height = 20,
    background_color = colors.bg_light,
    color = color,
  })

  controller.tooltip = awful.tooltip {
    mode = "mouse",
    align = "top_left",
    bg = colors.bg_normal,
    fg = colors.mid_light,
    font = user.font .. " bold 13",
  }

  controller.tooltip:add_to_object (controller.progress_bar)

  -- Label is static, no need to add to controller
  local label = helpers.textbox (colors.magenta, user.font .. " bold 16", name)
  label.forced_width = dpi (50)

  -- Final layout for the progress bar and label
  local final = wibox.widget ({
    helpers.margin (label, 15, 6, 0, 0),
    helpers.margin (controller.progress_bar, 6, 15, 0, 0),
    layout = wibox.layout.align.horizontal,
  })

  return helpers.margin (final, 3, 3, 15, 15), controller
end

local cpu_widget, cpu_controller = create_progress_widget("CPU", colors.orange)
local ram_widget, ram_controller = create_progress_widget("RAM", colors.green)
local disk_widget, disk_controller = create_progress_widget("DISK", colors.purple)

local function update_controller()
  awful.spawn.easy_async_with_shell(
  "echo \"$(top -bn1 | grep 'Cpu(s)' | awk '{print 100 - $8}') $(free | grep Mem | awk '{printf \"%.2f\", $3/$2 * 100.0}') $(df -h / | awk 'NR==2 {print $5}' | tr -d '%')\"",
  function(stdout)
    -- Split the stdout into CPU, RAM, and Disk values
    local cpu_usage, ram_usage, disk_usage = stdout:match("([%d%.]+) ([%d%.]+) ([%d]+)")

    -- Update each controller
    if cpu_usage then
      cpu_usage = tonumber (cpu_usage)
      cpu_controller.progress_bar:set_value (cpu_usage)
      cpu_controller.tooltip:set_text (cpu_usage)
    end
    if ram_usage then
      ram_usage = tonumber (ram_usage)
      ram_controller.progress_bar:set_value (ram_usage)
      ram_controller.tooltip:set_text (ram_usage)
    end
    if disk_usage then
      disk_usage = tonumber (disk_usage)
      disk_controller.progress_bar:set_value (disk_usage)
      disk_controller.tooltip:set_text (disk_usage)
    end
  end)
end

-- Timer to periodically update widgets
gears.timer {
  timeout = 5,
  autostart = true,
  call_now = true,
  callback = function()
    update_controller()
  end
}

local sys = wibox.widget ({
  {
    {
      cpu_widget,
      ram_widget,
      disk_widget,
      layout = wibox.layout.fixed.vertical,
    },
    widget = wibox.container.margin,
    margins = dpi (10),
  },
  widget = wibox.container.background,
  bg = colors.bg_normal,
  shape = helpers.rrect (0),
})

return helpers.margin (sys, 10, 10, 10, 10)
