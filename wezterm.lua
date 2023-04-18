local wezterm = require("wezterm")
local keys = require("keys")

-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- FIXME how to get something like padding = auto?
local function recompute_padding(window)
	local window_dims = window:get_dimensions()
	local overrides = window:get_config_overrides() or {}

	if not window_dims.is_full_screen then
		if not overrides.window_padding then
			return
		end
		overrides.window_padding = nil
	else
		local new_padding = {
			left = "0.7%",
			right = "0.7%",
			top = "0.67%",
			bottom = 0,
		}
		if overrides.window_padding and new_padding.left == overrides.window_padding.left then
			-- padding is same, avoid triggering further changes
			return
		end
		overrides.window_padding = new_padding
	end
	window:set_config_overrides(overrides)
end

wezterm.on("window-resized", function(
	window,
	_ --[[pane]]
)
	recompute_padding(window)
end)

wezterm.on("window-config-reloaded", function(window)
	recompute_padding(window)
end)

local function scheme_for_appearance(appearance)
  if appearance:find "Dark" then
    return "ChallengerDeep"
  else
    return "ChallengerDeep"
  end
end

local config = {}

if wezterm.config_builder then
    config = wezterm.config_builder()
end


config.use_ime = true
config.font = wezterm.font_with_fallback({
	"FiraCode Nerd Font",
	"Noto Sans CJK SC",
})
config.font_size = 14
config.leader = keys.leader
config.keys = keys.keys
config.tab_bar_at_bottom = true
config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())
config.tab_max_width = 25
config.hide_tab_bar_if_only_one_tab = false
config.show_tab_index_in_tab_bar = false
config.enable_scroll_bar = false
config.window_padding = {
	top = 5,
	bottom = 5,
	left = 5,
	right = 5,
}
config.adjust_window_size_when_changing_font_size = true
config.native_macos_fullscreen_mode = true
config.window_decorations = "RESIZE"
config.window_frame = {
	font = wezterm.font_with_fallback({
		"FiraCode Nerd Font",
		"Noto Sans CJK SC",
	}),
}
config.window_background_opacity = 0.9
config.window_background_image_hsb = {
	brightness = 0.8,
	hue = 1.0,
	saturation = 1.0,
}
config.window_close_confirmation = "NeverPrompt"
config.initial_rows = 30
config.initial_cols = 100

-- keys
config.disable_default_key_bindings = false
config.use_dead_keys = false

return config
