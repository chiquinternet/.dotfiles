local user = {

	--Profile
	name         = "pom",
	host         = "@tomato",
	user_img     = os.getenv("HOME") .. "/.config/awesome/assets/user.png",

	-- Default apps
	terminal     = "wezterm",
	file_manager = "nautilus",
	browser      = "firefox",
	editor       = "nvim",
	font         = "Ubuntu Nerd Font",

	wallpaper    = "~/Pictures/Wallpapers/chiffoncinnamoroll.png",
	icon_path    = os.getenv("HOME") .. "/.local/share/icons/Nordzy-pink/apps/scalable/",
  screenshot_path = os.getenv ("HOME") .. "/Pictures/Screenshots",
	-- icon_path    = os.getenv("HOME") .. "/.local/share/icons/Tela-circle-brown/scalable/apps/",
  -- icon_path    = os.getenv("HOME") .. "/.local/share/icons/Papirus/48x48/apps/",
	-- icon_path    = os.getenv("HOME") .. '/.icons/Tela/scalable/apps/',
	-- icon_path    = os.getenv("HOME") .. '/.icons/Zafiro-Icons-Dark-Blue-f/apps/scalable/',
	theme        = "rosepine_dawn",
	bar_floating = false,
}

user.dock_elements = {
	{ 'terminal',    user.terminal },
	{ user.browser,  user.browser },
	{ 'Thunar',      user.file_manager },
	{ 'telegram',    'telegram-desktop' },
	{ 'discord',     'vesktop' },
	{ 'krita' },
	{ 'obs' }
}

return user
