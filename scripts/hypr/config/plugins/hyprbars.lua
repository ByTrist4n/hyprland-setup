--------------------------
---- Plugin Hyprbars  ----
--------------------------

-- See https://github.com/hyprwm/hyprland-plugins/tree/main/hyprbars for more

local colors = require("config/colors")

hl.config({
  plugin = {
    hyprbars = {
      bar_height                 = 24,
      bar_color                  = colors.color2,
      bar_title_enabled          = false,
      bar_precedence_over_border = true,
      bar_buttons_alignment      = "left",
      bar_button_padding         = 5,
      bar_part_of_window         = true,
      icon_on_hover              = true,
    },
  },
})

-- Red Button: Close Window
hl.plugin.hyprbars.add_button({
  bg_color = "rgb(d94343)",
  fg_color = "rgb(ffC2bf)",
  size     = 16,
  icon     = "󰖭",
  action   = "hyprctl dispatch 'hl.dsp.window.close()'",
})

-- Green Button: Maximize / Fullscreen
hl.plugin.hyprbars.add_button({
  bg_color = "rgb(68d938)",
  fg_color = "rgb(213321)",
  size     = 16,
  icon     = "",
  action   = [[hyprctl dispatch 'hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })']],
})