-- WezTerm configuration file
-- Infos under: https://wezfurlong.org/wezterm/index.html
local wezterm = require 'wezterm'

return {
	-- Run this on startup (should be a shell)
	default_prog = { '/usr/bin/zsh', '-l' },

	---- Font ----
	-- List of fonts to use (order = prority)
	-- font = wezterm.font 'Fira Code',
    -- font = wezterm.font 'IBM Plex Mono',
	font = wezterm.font {
        family =  'Monaspace Neon',
        -- https://github.com/githubnext/monaspace#coding-ligatures
        -- I only want the 'texture healing'
        harfbuzz_features = { 'calt' },
    },
	-- Font size
	font_size = 11.0,
	-- "underline" thickness (affects basically all lines though)
	underline_thickness = '1.25pt',
	warn_about_missing_glyphs=false,

	---- Appearence ----
	-- Colour scheme
    --color_scheme = 'Monokai Soda',
	color_scheme = 'catppuccin-mocha',
	-- background opacity
	window_background_opacity = 0.95,
	-- Tabs
	hide_tab_bar_if_only_one_tab = true,
	use_fancy_tab_bar = true,
	tab_bar_at_bottom = false,
	-- Cursor
	default_cursor_style = 'BlinkingBar',
	cursor_blink_rate = 600,
	-- Make cursor a lock on password inputs
	detect_password_input = true,
	-- Window size
	initial_cols = 120,
	initial_rows = 40,

	---- Scrollback ----
	-- size
	scrollback_lines = 15000,
	-- Enable the scrollbar.
  	-- It will occupy the right window padding space.
  	-- If right padding is set to 0 then it will be increased
  	-- to a single cell width
  	enable_scroll_bar = false,

	---- Controls ----
	-- unzoom when switching panes
	unzoom_on_switch_pane = true,
    
    ---- Multiplexing ----
    -- local
    unix_domains = {
        {
            name = 'unix',
        },
    },

    -- default_gui_startup_args = { 'connect', 'unix' },

}
