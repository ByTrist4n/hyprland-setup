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
  hl.exec_cmd("wl-paste --type text --watch cliphist store") -- Start cliphist watching text clipboard data
  hl.exec_cmd("wl-paste --type image --watch cliphist store") -- Start cliphist watching image clipboard data
end)
