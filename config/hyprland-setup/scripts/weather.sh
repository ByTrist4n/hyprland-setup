#!/usr/bin/env bash
# Usage: weather.sh [icon|temp|desc|wind|city]
# Cache 10 min in /tmp/hyprlock-weather.json

CACHE="/tmp/hyprlock-weather.json"
CACHE_TIME=600

code_to_icon() {
  local c=$1
  if [[ $c -eq 113 ]]; then
    echo ""
  elif [[ $c -eq 116 ]]; then
    echo "󰖕"
  elif [[ $c -eq 119 || $c -eq 122 ]]; then
    echo "󰖐"
  elif [[ $c -ge 176 && $c -le 185 ]]; then
    echo "󰼳"
  elif [[ $c -ge 200 && $c -le 201 ]]; then
    echo "󰙾"
  elif [[ $c -ge 293 && $c -le 353 ]]; then
    echo "󰼳"
  elif [[ $c -ge 354 && $c -le 395 ]]; then
    echo "󰖖"
  else
    echo "🌡"
  fi
}

# Check cache validity
needs_refresh=true
if [[ -f "$CACHE" ]]; then
  file_mtime=$(stat -c %Y "$CACHE" 2> /dev/null || stat -f %m "$CACHE" 2> /dev/null || echo 0)
  age=$(($(date +%s) - file_mtime))
  [[ $age -lt $CACHE_TIME ]] && needs_refresh=false
fi

# Fetch new weather data if cache expired
if $needs_refresh; then
  CITY=$(curl -sf --max-time 3 "https://ipinfo.io/city" 2> /dev/null || echo "")
  URL="https://wttr.in/${CITY}?format=j1"
  curl -sf --max-time 5 "$URL" -o "$CACHE" 2> /dev/null || true
fi

[[ ! -f "$CACHE" ]] && echo "--" && exit 0

case "${1:-icon}" in
  icon)
    code=$(jq -r '.current_condition[0].weatherCode' "$CACHE" 2> /dev/null || echo "113")
    code_to_icon "$code"
    ;;
  temp)
    jq -r '.current_condition[0].temp_C + "°C"' "$CACHE" 2> /dev/null || echo "--°C"
    ;;
  desc)
    jq -r '.current_condition[0].weatherDesc[0].value' "$CACHE" 2> /dev/null || echo ""
    ;;
  wind)
    jq -r '" " + .current_condition[0].windspeedKmph + " km/h"' "$CACHE" 2> /dev/null || echo ""
    ;;
  city)
    jq -r '.nearest_area[0].areaName[0].value' "$CACHE" 2> /dev/null || echo ""
    ;;
esac
