#!/usr/bin/env bash
# Interactive screen recording launcher using wf-recorder and Hyprland IPC

VIDEOS_DIR="$HOME/Videos"
mkdir -p "$VIDEOS_DIR"

# Stop existing recording if already running
if pgrep -x "wf-recorder" > /dev/null; then
    killall -INT wf-recorder
    notify-send "Screen Recorder" "Recording stopped" -i video-x-generic
    exit 0
fi

CHOICE=$(echo -e "1. Area selection (Zone)\n2. Active window\n3. Full screen" | rofi -dmenu -p "Record mode:")

TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
OUTPUT_FILE="$VIDEOS_DIR/recording_${TIMESTAMP}.mp4"

case "$CHOICE" in
    *"Area"*)
        # Interactive region drag with slurp
        GEOM=$(slurp)
        ;;
    *"Active window"*)
        # Get active window geometry from Hyprland IPC
        GEOM=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
        ;;
    *"Full screen"*)
        # Get focused monitor geometry from Hyprland IPC
        GEOM=$(hyprctl monitors -j | jq -r '.[] | select(.focused==true) | "\(.x),\(.y) \(.width)x\(.height)"')
        ;;
    *)
        exit 0
        ;;
esac

# Start recording if geometry is valid
if [ -n "$GEOM" ] && [ "$GEOM" != "null" ]; then
    wf-recorder -g "$GEOM" -f "$OUTPUT_FILE" &
    notify-send "Screen Recorder" "Recording started..." -i video-x-generic
    sleep 0.5
fi