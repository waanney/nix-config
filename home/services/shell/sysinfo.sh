#!/usr/bin/env bash

# Fetch WiFi SSID
wifi=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2 | head -n1)
if [ -z "$wifi" ]; then wifi="Disconnected"; fi

# Fetch Battery Info
bat_cap=$(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null || echo "100")
bat_status=$(cat /sys/class/power_supply/BAT1/status 2>/dev/null || echo "Unknown")

# Fetch Volume Info
vol_info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null || echo "Volume: 0.0")
vol=$(echo "$vol_info" | awk '{print int($2*100)}')
muted=$(echo "$vol_info" | grep -q "MUTED" && echo "true" || echo "false")

# Fetch Brightness
bright_pct=$(brightnessctl -m | cut -d, -f4 | tr -d '%' 2>/dev/null || echo "100")

# Fetch Memory usage (RAM)
ram=$(free | awk '/Mem:/ {print int($3/$2*100)}')

# Fetch CPU usage (using vmstat over 0.5s to be fast but accurate)
cpu=$(vmstat 1 2 | tail -n 1 | awk '{print 100 - $15}' 2>/dev/null || echo "0")

# Print as clean JSON
echo "{\"wifi\":\"$wifi\",\"bat_cap\":$bat_cap,\"bat_status\":\"$bat_status\",\"vol\":$vol,\"muted\":$muted,\"brightness\":$bright_pct,\"ram\":$ram,\"cpu\":$cpu}"
