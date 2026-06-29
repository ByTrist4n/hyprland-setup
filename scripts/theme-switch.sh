#!/bin/bash
wallpaper_dir="$HOME/Pictures/Wallpapers"
hypr_colors="$HOME/.config/hypr/config/colors.lua"
wal_colors="$HOME/.cache/wal/colors.lua"

# Select wallpaper with wofi
wallpaper=$(find "$wallpaper_dir" -type f | rofi -dmenu -p "Wallpaper")
[ -z "$wallpaper" ] && exit 0

# Apply wallpaper with transition
awww img "$wallpaper" --transition-type grow --transition-duration 1

# Generate colors via wpgtk (updates oomox, pywal and our Kvantum templates)
wpg -s "$wallpaper"

# Wlogout replaces SVG fill colors with dynamic wal colors
COLOR_WAL=$(grep -oP '"color15": "\K[^"]+' ~/.cache/wal/colors.json)
find ~/.config/wlogout/assets/ -name "*.svg" -exec sed -i "s/fill=\"#[0-9a-fA-F]\{6\}\"/fill=\"$COLOR_WAL\"/g" {} +

# Hyprland Config colors
cp "$wal_colors" "$hypr_colors"

# Refresh waybar and hyprland
pkill waybar; waybar & disown
hyprctl reload

notify-send "🎨 Theme Updated" "$(basename "$wallpaper")"
