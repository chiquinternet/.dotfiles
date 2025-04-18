local wibox = require ("wibox")

-----------------------------
--Widgets--------------------
-----------------------------
local tabs = require ("layout.panel.tabs")
local control = require ("layout.panel.control_center")
local calendar = require ("layout.panel.calendar")
local todo = require ("layout.panel.todo")

local panel = wibox.widget ({
  control,
  calendar,
  todo,
  {
    nil,
    nil,
    tabs,
    layout = wibox.layout.align.vertical,
  },
  layout = wibox.layout.stack,
})

awesome.connect_signal ("panel::calendar", function ()
  control.visible = false
  todo.visible = false
  calendar.visible = true
end)

awesome.connect_signal ("panel::control", function ()
  control.visible = true
  todo.visible = false
  calendar.visible = false
end)

awesome.connect_signal ("panel::todo", function ()
  control.visible = false
  todo.visible = true
  calendar.visible = false
end)

control:connect_signal ("property::visible", function ()
  if control.visible then
    activate_click_outside_to_close (control)
  end
end)

return panel
