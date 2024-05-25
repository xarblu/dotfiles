-- WezTerm configuration file
-- Infos under: https://wezfurlong.org/wezterm/index.html
local wezterm = require('wezterm')

-- Config table, use config_builder if available
local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end

---- Font ----
-- List of fonts to use (order = prority)
config.font = wezterm.font {
    family =  'Monaspace Neon',
    -- https://github.com/githubnext/monaspace#coding-ligatures
    -- I only want the 'texture healing'
    harfbuzz_features = { 'calt' },
}
-- Font size
config.font_size = 11.0
-- "underline" thickness (affects basically all lines though)
config.underline_thickness = '1.25pt'
config.warn_about_missing_glyphs = false

---- Appearence ----
-- Colour scheme
config.color_scheme = 'catppuccin-mocha'
-- background opacity
config.window_background_opacity = 0.95
-- Cursor
config.default_cursor_style = 'BlinkingBar'
-- Make cursor a lock on password inputs
config.detect_password_input = true

---- Scrollback ----
config.scrollback_lines = 15000

---- Controls ----
-- unzoom when switching panes
config.unzoom_on_switch_pane = true
-- Tabs
config.hide_tab_bar_if_only_one_tab = true

---- GUI/Window ----
-- Pick first GPU with Vulkan backend
for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
  if gpu.backend == 'Vulkan' and (gpu.device_type == 'DiscreteGPU' or gpu.device_type == 'IntegratedGPU') then
    config.webgpu_preferred_adapter = gpu
    config.front_end = 'WebGpu'
    break
  end
end
-- if not found pick base OpenGL
if not config.front_end then
    config.front_end = 'OpenGL'
end
-- Window size
config.initial_cols = 120
config.initial_rows = 40

---- Misc ----
-- set TERM to wezterm (needs terminfo installed)
-- config.term = 'wezterm'
-- Run this on startup (should be a shell)
config.default_prog = { '/usr/bin/zsh', '-l' }

-- return final config
return config
