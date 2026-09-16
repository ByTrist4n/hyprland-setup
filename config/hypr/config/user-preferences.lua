-- ===================================================
-- User Preferences & Application Defaults
-- Custom application definitions and UI constants
-- ===================================================

local userPrefs = {
  -- Core Applications
  apps = {
    terminal = "kitty",
    fileManager = "dolphin",
    menu = "rofi -show drun",
    browser = "zen-browser",
    editor = "codium",
  },

  -- Custom Hardware Keycodes / Keybindings
  keyboard = {
    f3 = "code:128", -- Custom F3 key mapping
  },

  theme = {
    borderSize = 2,
    gapsIn = 5,
    gapsOut = 10,
  },
}

return userPrefs
