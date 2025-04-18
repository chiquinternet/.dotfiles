local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")

local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local color = require("themes.colors")

local user = require("user")
local iconpath = os.getenv("HOME") .. "/.config/awesome/assets/weather_icons/"

local api_key = "e3578ff20a78750dbfc8f2e9ece0c0d1"
local city = "Curitiba"
local country_code = "BR"
local weather_api = "https://api.openweathermap.org/data/2.5/weather?q="
	.. city
	.. ","
	.. country_code
	.. "&appid="
	.. api_key
	.. "&units=metric"

--------------------------
--Base_widgets------------
--------------------------
local location_icon = "  "
local location_text = helpers.textbox(color.lightblue, user.font .. " bold 20", "Curitiba, BR")
local weather_text = helpers.textbox(color.lightblue, user.font .. " bold 12", "Loading...")
local temp_text = helpers.textbox(color.fg_normal, user.font .. " bold 30", " " .. "°C")

local humid_icon = helpers.textbox(color.blue, user.font .. " bold 17", "󱪅 ")
local wind_icon = helpers.textbox(color.blue, user.font .. " bold 17", " ")
local feelslike_icon = helpers.textbox(color.blue, user.font .. " bold 17", "󱤋  ")

local humid_text = helpers.textbox(color.fg_normal, user.font .. " 14", "N/A")
local wind_text = helpers.textbox(color.fg_normal, user.font .. " 14", "N/A")
local feelslike_text = helpers.textbox(color.fg_normal, user.font .. " 14", "N/A")

local weath_image = helpers.imagebox(iconpath .. "weather-error.svg", 70, 70)

local weather_icons = {
	[800] = "sun_icon.svg", -- Clear sky
	[801] = "dfew_clouds.svg", -- Few clouds
	[802] = "dscattered_clouds.svg", -- Scattered clouds
	[803] = "dbroken_clouds.svg", -- Broken clouds
	[804] = "dscattered_clouds.svg", -- Overcast clouds
	[500] = "dshower_rain.svg", -- Light rain
	[501] = "d_rain.svg", -- Moderate rain
	[502] = "d_rain.svg", -- Heavy rain
	[503] = "d_rain.svg", -- Very heavy rain
	[504] = "d_rain.svg", -- Extreme rain
	[200] = "nthunderstorm.svg", -- Thunderstorm with light rain
	[201] = "nthunderstorm.svg", -- Thunderstorm with rain
	[202] = "nthunderstorm.svg", -- Thunderstorm with heavy rain
	[210] = "nthunderstorm.svg", -- Light thunderstorm
	[211] = "nthunderstorm.svg", -- Thunderstorm
	[212] = "nthunderstorm.svg", -- Heavy thunderstorm
	[221] = "nthunderstorm.svg", -- Ragged thunderstorm
	[300] = "nshower_rain.svg", -- Light drizzle
	[301] = "nshower_rain.svg", -- Drizzle
	[302] = "nshower_rain.svg", -- Heavy drizzle
	[310] = "nshower_rain.svg", -- Light drizzle rain
	[311] = "nshower_rain.svg", -- Drizzle rain
	[312] = "nshower_rain.svg", -- Heavy drizzle rain
	[313] = "nshower_rain.svg", -- Shower rain and drizzle
	[314] = "nshower_rain.svg", -- Heavy shower rain and drizzle
	[321] = "nshower_rain.svg", -- Shower drizzle
	[600] = "snow.svg", -- Light snow
	[601] = "snow.svg", -- Snow
	[602] = "snow.svg", -- Heavy snow
	[611] = "snow.svg", -- Sleet
	[612] = "snow.svg", -- Light sleet
	[613] = "snow.svg", -- Shower sleet
	[615] = "snow.svg", -- Light rain and snow
	[616] = "snow.svg", -- Rain and snow
	[620] = "snow.svg", -- Light shower snow
	[621] = "snow.svg", -- Shower snow
	[622] = "snow.svg", -- Heavy shower snow
	[701] = "dmist.svg", -- Mist
	[711] = "dmist.svg", -- Smoke
	[721] = "dmist.svg", -- Haze
	[731] = "dmist.svg", -- Sand/dust
	[741] = "dmist.svg", -- Fog
	[751] = "dmist.svg", -- Sand
	[761] = "dmist.svg", -- Dust
	[762] = "dmist.svg", -- Volcanic ash
	[771] = "nthunderstorm.svg", -- Squalls
	[781] = "nthunderstorm.svg", -- Tornado
}

local function update_weather()
	awful.spawn.easy_async_with_shell("curl -s '" .. weather_api .. "'", function(stdout)
		-- Parse JSON response
		local json = require("dkjson") -- Requires LuaJSON module
		local weather_data, pos, err = json.decode(stdout, 1, nil)

		if err then
			weather_text:set_text("Error at position " .. pos .. " while fetching weather")
			return
		end

		local city_name = weather_data.name
		local country = weather_data.sys.country
		local weather_id = weather_data.weather[1].id
		local weather_description = weather_data.weather[1].description
		local temp = math.floor(weather_data.main.temp)
		local feels_like = math.floor(weather_data.main.feels_like)
		local humidity = weather_data.main.humidity
		local wind_speed = weather_data.wind.speed

		location_text:set_text(location_icon .. city_name .. ", " .. country)
		weather_text:set_text(weather_description:gsub("^%l", string.upper))
		temp_text:set_text(temp .. "°C")
		humid_text:set_text(humidity .. "%")
		feelslike_text:set_text(feels_like .. "°C")
		wind_text:set_text(wind_speed .. " m/s")

		local weather_icon = weather_icons[weather_id] or "weather-error.svg"
		weath_image:set_image(iconpath .. weather_icon)
	end)
end

gears.timer({
	timeout = 60,
	call_now = true,
	autostart = true,
	callback = update_weather,
})

--Bottom containers
local container = function(wgt1, wgt2, width)
	return wibox.widget({
		{
			{
				{
					wgt1,
					nil,
					wgt2,
					layout = wibox.layout.align.horizontal,
				},
				widget = wibox.container.margin,
				forced_width = dpi(width),
				left = dpi(10),
				right = dpi(10),
				top = dpi(5),
				bottom = dpi(5),
			},
			widget = wibox.container.background,
			bg = color.bg_light,
			shape = helpers.rrect(0),
		},
		widget = wibox.container.margin,
		margins = dpi(0),
	})
end

local wgt = wibox.widget({
	{
		{
			{
				helpers.margin({
					location_text,
					nil,
					weather_text,
					layout = wibox.layout.align.horizontal,
				}, 5, 5, 10, 10),
				helpers.margin({
					temp_text,
					nil,
					weath_image,
					layout = wibox.layout.align.horizontal,
				}, 10, 5, 5, 10),
				helpers.margin({
					{
						helpers.margin(container(humid_icon, humid_text, 115), 5, 12, 0, 0),
						helpers.margin(container(feelslike_icon, feelslike_text, 115), 12, 12, 0, 0),
						helpers.margin(container(wind_icon, wind_text, 120), 12, 5, 0, 0),
						layout = wibox.layout.align.horizontal,
					},
					widget = wibox.container.place,
				}, 0, 0, 0, 10),
				layout = wibox.layout.fixed.vertical,
			},
			widget = wibox.container.margin,
			margins = dpi(20),
		},
		widget = wibox.container.background,
		bg = color.bg_normal,
		shape = helpers.rrect(0),
	},
	widget = wibox.container.margin,
	margins = dpi(10),
	forced_width = dpi(450),
})

return wgt
