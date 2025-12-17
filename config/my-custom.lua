-- ==============================================================================
-- MY CUSTOM ACCESSIBILITY & KEYBINDING OVERRIDES
-- ==============================================================================
-- Purpose: Hardened patch for macOS accessibility including:
--          - Cmd+Arrow word navigation (not Home/End)
--          - Thick text rendering (HorizontalLcd)
--          - Alternative font options
--          - Black background (no cartoon wallpapers)
--          - F-keys pass-through to terminal (tmux, byobu, vim)
--          - Zsh as default shell (not fish)
-- Maintained on branch: my-custom-setup
-- ==============================================================================

local wezterm = require('wezterm')
local platform = require('utils.platform')

-- ============================================================================
-- 1. TEXT RENDERING (Thick/Bold Text for Accessibility)
-- ============================================================================
-- HorizontalLcd provides subpixel antialiasing with thicker strokes.
-- This OVERRIDES the default 'Normal' setting from config/fonts.lua
-- Alternatives: 'Light', 'Normal', 'Mono', 'HorizontalLcd'

local freetype_target = 'HorizontalLcd'

-- ============================================================================
-- 2. FONT CONFIGURATION
-- ============================================================================
-- These settings OVERRIDE config/fonts.lua when enabled.
-- Default: Use the base config's JetBrains Mono settings (nil = no override)
--
-- To enable accessibility fonts, uncomment ONE of the font_config blocks below.

-- To use base config's JetBrains Mono, set font_config = nil
-- local font_config = nil

-- OPTION A: JetBrains Mono with larger size
-- font_config = {
--    font = wezterm.font({
--       family = 'JetBrainsMono Nerd Font',
--       weight = 'Medium',
--    }),
--    font_size = platform.is_mac and 14 or 11,
-- }

-- OPTION B: Atkinson Hyperlegible (High readability, distinct characters)
-- NOTE: Uses base font + Symbols fallback since no Nerd Font version exists
-- font_config = {
--    font = wezterm.font_with_fallback({
--       { family = 'Atkinson Hyperlegible', weight = 'Regular' },
--       'Symbols Nerd Font Mono',
--       'JetBrainsMono Nerd Font',
--    }),
--    font_size = platform.is_mac and 15 or 12,
-- }

-- OPTION C: OpenDyslexic Nerd Font (high readability monospace) [ACTIVE]
-- Adjust font_size and line_height to taste
local font_config = {
   font = wezterm.font({
      family = 'OpenDyslexicM Nerd Font Mono',
      weight = 'Regular',
   }),
   font_size = 7.5,
   cell_width = 0.9,  -- Tighter letter spacing
   line_height = 0.9,  -- Tighter line spacing (1.0 = normal)
}

-- OPTION D: Inconsolata (your iTerm2 font) - install with: brew install font-inconsolata-nerd-font
-- font_config = {
--    font = wezterm.font_with_fallback({
--       { family = 'Inconsolata', weight = 'Regular' },
--       'Symbols Nerd Font Mono',
--       'JetBrainsMono Nerd Font',
--    }),
--    font_size = platform.is_mac and 11 or 10,
-- }

-- ============================================================================
-- 3. macOS CMD+ARROW WORD NAVIGATION
-- ============================================================================
-- NOTE: Key bindings are modified in config/bindings.lua (search for "MY-CUSTOM")
-- because Config:append() skips duplicate keys.
--
-- The following bindings were changed in bindings.lua:
--   Cmd+Left  -> ESC b (word backward) - was: Home
--   Cmd+Right -> ESC f (word forward)  - was: End
--   Cmd+Backspace -> Ctrl-u (delete to beginning of line) - unchanged
--
-- Option+Arrow is intentionally left unbound for byobu tab switching.

-- ============================================================================
-- 4. CURSOR VISIBILITY (Accessibility)
-- ============================================================================
-- NOTE: Cursor settings are in config/appearance.lua (BlinkingBlock @ 650ms).
-- The base config's cursor settings work well. If you need to change them,
-- edit config/appearance.lua directly since Config:append() skips duplicates.
--
-- Default cursor settings in appearance.lua:
--   default_cursor_style = 'BlinkingBlock'
--   cursor_blink_rate = 650
--   cursor_blink_ease_in = 'EaseOut'
--   cursor_blink_ease_out = 'EaseOut'

-- ============================================================================
-- 5. F-KEY PASS-THROUGH
-- ============================================================================
-- NOTE: All F-key bindings (F1-F12) were REMOVED from config/bindings.lua
-- to allow pass-through to terminal apps like tmux, byobu, and vim.
--
-- Original bindings that were removed:
--   F1  -> ActivateCopyMode (WezTerm)
--   F2  -> CommandPalette (WezTerm) - conflicts with tmux rename-window
--   F3  -> ShowLauncher (WezTerm)
--   F4  -> ShowLauncher FUZZY|TABS (WezTerm)
--   F5  -> ShowLauncher FUZZY|WORKSPACES (WezTerm)
--   F11 -> ToggleFullScreen (WezTerm)
--   F12 -> ShowDebugOverlay (WezTerm)
--
-- Now all F-keys pass through to terminal applications.

-- ============================================================================
-- 6. DEFAULT SHELL
-- ============================================================================
-- NOTE: Default shell changed from fish to zsh in config/launch.lua
-- The original config hardcoded '/opt/homebrew/bin/fish' which may not exist.
--
-- Current setting: options.default_prog = { 'zsh', '-l' }
-- Other shells available in launch menu: Bash, Fish, Nushell

-- ============================================================================
-- 7. BACKGROUND
-- ============================================================================
-- NOTE: Background set to solid black in wezterm.lua using:
--   require('utils.backdrops'):set_focus('#000000')
--
-- The original config used :set_images():random() for anime wallpapers.
-- To restore random backgrounds: edit wezterm.lua, change to :set_images():random()

-- ============================================================================
-- 8. BUILD RETURN TABLE
-- ============================================================================
-- Only include settings that should override the base config
-- NOTE: Keys are in bindings.lua, fonts in fonts.lua - this handles rendering only
-- NOTE: Cursor settings are in appearance.lua (loaded before this module)

local config = {}

-- Merge font config if enabled (font/font_size override fonts.lua)
if font_config then
   for k, v in pairs(font_config) do
      config[k] = v
   end
end

-- Text rendering (always apply for accessibility)
-- These override the 'Normal' settings in fonts.lua for thicker text
config.freetype_load_target = freetype_target
config.freetype_render_target = freetype_target

-- MY-CUSTOM: Color scheme
-- VSCodeDark+ has better contrast (white commands, grey output, colored syntax)
-- To revert to Catppuccin Mocha, comment out color_scheme line
config.color_scheme = 'VSCodeDark+ (Gogh)'
-- Colors extracted from iTerm2 ~/Library/Preferences/com.googlecode.iterm2.plist
config.colors = {
   background = '#000000',
   foreground = '#bbbbbb',
   -- Normal ANSI colors (0-7) from iTerm2
   ansi = {
      '#000000',  -- 0: black
      '#bb0000',  -- 1: red
      '#00bb00',  -- 2: green
      '#bbbb00',  -- 3: yellow
      '#0000bb',  -- 4: blue
      '#bb00bb',  -- 5: magenta
      '#00bbbb',  -- 6: cyan
      '#bbbbbb',  -- 7: white
   },
   -- Bright ANSI colors (8-15) from iTerm2
   brights = {
      '#555555',  -- 8: bright black
      '#ff5555',  -- 9: bright red
      '#55ff55',  -- 10: bright green
      '#ffff55',  -- 11: bright yellow
      '#5555ff',  -- 12: bright blue
      '#ff55ff',  -- 13: bright magenta
      '#55ffff',  -- 14: bright cyan
      '#ffffff',  -- 15: bright white
   },
}

return config
