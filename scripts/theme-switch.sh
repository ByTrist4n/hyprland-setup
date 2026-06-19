#!/bin/bash
WALL_DIR="$HOME/Pictures/Wallpapers"

# Select wallpaper with wofi
WALLPAPER=$(find "$WALL_DIR" -type f | rofi -dmenu -p "Wallpaper")
[ -z "$WALLPAPER" ] && exit 0

# Apply wallpaper with transition
awww img "$WALLPAPER" --transition-type grow --transition-duration 1

# Generate colors via wpgtk (updates oomox, pywal and our Kvantum templates)
wpg -s "$WALLPAPER"

# Wlogout replaces SVG fill colors with dynamic wal colors
COLOR_WAL=$(grep -oP '"color15": "\K[^"]+' ~/.cache/wal/colors.json)
find ~/.config/wlogout/assets/ -name "*.svg" -exec sed -i "s/fill=\"#[0-9a-fA-F]\{6\}\"/fill=\"$COLOR_WAL\"/g" {} +

# Refresh waybar and hyprland
pkill waybar; waybar & disown
hyprctl reload

notify-send "🎨 Theme Updated" "$(basename "$WALLPAPER")"
