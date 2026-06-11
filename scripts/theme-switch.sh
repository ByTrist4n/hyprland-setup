#!/bin/bash
WALL_DIR="$HOME/Pictures/Wallpapers"

# Select wallpaper with wofi
WALLPAPER=$(find "$WALL_DIR" -type f | wofi -dmenu -p "Wallpaper")
[ -z "$WALLPAPER" ] && exit 0

# Apply wallpaper with transition
awww img "$WALLPAPER" --transition-type grow --transition-duration 1

# Generate colors via wpgtk (updates oomox, pywal and our Kvantum templates)
wpg -s "$WALLPAPER"

# Refresh waybar and hyprland
pkill waybar; waybar & disown
hyprctl reload

# Restart pavucontrol if open
if pgrep -x pavucontrol > /dev/null; then
    pkill pavucontrol; sleep 0.3; pavucontrol & disown
fi

notify-send "🎨 Theme Updated" "$(basename "$WALLPAPER")"


