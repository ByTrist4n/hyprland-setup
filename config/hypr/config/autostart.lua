-- ===================================================
-- AUTOSTART
-- ===================================================

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
  hl.exec_cmd("nm-applet")
  hl.exec_cmd("hyprpm reload")
  hl.exec_cmd("elephant")
  hl.exec_cmd("walker --gapplication-service")
  hl.exec_cmd("fcitx5 -d")
  hl.exec_cmd("hypridle")
  hl.exec_cmd("awww-daemon")
  hl.exec_cmd("quickshell")
end)
