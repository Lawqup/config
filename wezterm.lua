local wezterm = require 'wezterm'
local act = wezterm.action

return {
	color_scheme = 'Catppuccin Mocha',
	window_decorations = "RESIZE",
	enable_tab_bar = false,
	keys = {
		{ key = "p",   mods = "CTRL", action = act.ScrollToPrompt(-1) },
		{ key = "n", mods = "CTRL", action = act.ScrollToPrompt(1) },
	},
}
