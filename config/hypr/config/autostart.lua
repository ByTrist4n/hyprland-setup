-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("hyprpm reload")
    hl.exec_cmd("fcitx5 -d")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("quickshell")
    hl.exec_cmd("zen-browser", { workspace = "2 silent" })
    hl.exec_cmd("codium'", { workspace = "2 silent" })
    hl.exec_cmd("bash -c 'nm-online -q && pear-desktop'", { workspace = "special:magic silent" })
end)
