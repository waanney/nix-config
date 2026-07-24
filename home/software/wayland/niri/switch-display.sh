#!/usr/bin/env bash

STATE_FILE="/tmp/niri_display_state"

if [ ! -f "$STATE_FILE" ]; then
    echo "0" > "$STATE_FILE"
fi

STATE=$(cat "$STATE_FILE")

# Check if HDMI is connected
if ! niri msg outputs | grep -q "HDMI-A-1"; then
    notify-send "Display Mode" "No HDMI monitor connected."
    echo "0" > "$STATE_FILE"
    exit 0
fi

case $STATE in
    0)
        # Extend Right
        niri msg output eDP-1 on
        niri msg output HDMI-A-1 on
        niri msg output eDP-1 position set 0 0
        niri msg output HDMI-A-1 position set 2048 0
        notify-send "Display Mode" "Extend (HDMI on Right)" -t 2000
        echo "1" > "$STATE_FILE"
        ;;
    1)
        # Extend Left
        niri msg output eDP-1 on
        niri msg output HDMI-A-1 on
        niri msg output eDP-1 position set 0 0
        niri msg output HDMI-A-1 position set -- -1920 0
        notify-send "Display Mode" "Extend (HDMI on Left)" -t 2000
        echo "2" > "$STATE_FILE"
        ;;
    2)
        # HDMI Only
        niri msg output HDMI-A-1 on
        niri msg output HDMI-A-1 position set 0 0
        niri msg output eDP-1 off
        notify-send "Display Mode" "HDMI Only (Laptop screen off)" -t 2000
        echo "3" > "$STATE_FILE"
        ;;
    3)
        # Laptop Only
        niri msg output eDP-1 on
        niri msg output eDP-1 position set 0 0
        niri msg output HDMI-A-1 off
        notify-send "Display Mode" "Laptop Only (HDMI off)" -t 2000
        echo "0" > "$STATE_FILE"
        ;;
esac
