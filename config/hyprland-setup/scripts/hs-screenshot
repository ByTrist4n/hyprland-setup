#!/usr/bin/env bash

# Determine capture mode based on argument (default: save, alternate: clipboard)
MODE="${1:-save}"

if [ "$MODE" = "clipboard" ]; then
  # Temporary file workflow for clipboard copying
  tmp="/tmp/satty_preview_$(date +%s).png"
  grim -g "$(slurp)" "$tmp" && satty --filename "$tmp" --early-exit --copy-command "wl-copy" --disable-notifications && notify-send -i "$tmp" "Screenshot copied" "Image copied to clipboard"
  rm -f "$tmp"
else
  # Persistent save workflow with timestamp
  f="$HOME/Pictures/Screenshots/satty-$(date +%Y%m%d-%H%M%S).png"
  mkdir -p "$(dirname "$f")"
  grim -g "$(slurp)" "$f" && satty --filename "$f" --output-filename "$f" --early-exit --copy-command "wl-copy" --disable-notifications && notify-send -i "$f" "Screenshot saved" "Image saved to Screenshots directory"
fi
