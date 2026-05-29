#!/usr/bin/env bash

# Fetch WiFi SSID
wifi=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2 | head -n1)
if [ -z "$wifi" ]; then wifi="Disconnected"; fi

# Fetch IP Address
ip_addr=$(hostname -I | awk '{print $1}')
if [ -z "$ip_addr" ]; then ip_addr="127.0.0.1"; fi

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
ram_detail=$(free -h | awk '/Mem:/ {print $3 " / " $2}' | tr -d 'i')

# Fetch CPU usage
cpu=$(vmstat 1 2 | tail -n 1 | awk '{print 100 - $15}' 2>/dev/null || echo "0")
cpu_temp=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null | awk '{print int($1/1000)}')
if [ -z "$cpu_temp" ]; then cpu_temp="0"; fi

# Fetch Uptime
uptime_info=$(awk '{print int($1/3600) "h " int(($1%3600)/60) "m"}' /proc/uptime)

# Fetch Media Info
media_title=""
media_artist=""
media_status="Stopped"
if command -v playerctl >/dev/null 2>&1; then
    media_status=$(playerctl status 2>/dev/null || echo "Stopped")
    if [ "$media_status" != "Stopped" ]; then
        media_title=$(playerctl metadata title 2>/dev/null | sed 's/"/\\"/g' | head -n1)
        media_artist=$(playerctl metadata artist 2>/dev/null | sed 's/"/\\"/g' | head -n1)
    fi
fi

if [ -z "$media_title" ]; then media_title="Nothing playing"; fi
if [ -z "$media_artist" ]; then media_artist="Idle"; fi

# Print as clean JSON
echo "{\"wifi\":\"$wifi\",\"ip_addr\":\"$ip_addr\",\"bat_cap\":$bat_cap,\"bat_status\":\"$bat_status\",\"vol\":$vol,\"muted\":$muted,\"brightness\":$bright_pct,\"ram\":$ram,\"ram_detail\":\"$ram_detail\",\"cpu\":$cpu,\"cpu_temp\":$cpu_temp,\"uptime\":\"$uptime_info\",\"media_title\":\"$media_title\",\"media_artist\":\"$media_artist\",\"media_status\":\"$media_status\"}"
