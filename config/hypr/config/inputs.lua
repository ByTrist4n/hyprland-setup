-- ===================================================
--  INPUT
-- ===================================================

hl.config({
  input = {
    -- Keyboard Layout Settings
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "caps:escape", -- map CapsLock to Escape
    kb_rules = "",

    -- Mouse Focus Settings
    follow_mouse = 1,
    sensitivity = 0, -- -1.0 to 1.0 (0 means no sensitivity modification)

    -- Touchpad Settings
    touchpad = {
      natural_scroll = true,
      scroll_factor = 1.0,
      tap_to_click = true,
    },
  },
  cursor = {
    no_warps = true,
  },
})

-- Touchpad Gestures Configuration
hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})

-- Per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
  name = "epic-mouse-v1",
  sensitivity = -0.5,
})
