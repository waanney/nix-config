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
media_source=""
media_position=0
media_length=0
if command -v playerctl >/dev/null 2>&1; then
    media_status=$(playerctl status 2>/dev/null || echo "Stopped")
    if [ "$media_status" != "Stopped" ]; then
        media_title=$(playerctl metadata title 2>/dev/null | sed 's/"/\\"/g' | head -n1)
        media_artist=$(playerctl metadata artist 2>/dev/null | sed 's/"/\\"/g' | head -n1)
        # Detect which player is active (spotify, firefox, vlc, etc.)
        media_source=$(playerctl metadata --format '{{playerName}}' 2>/dev/null | head -n1 | sed 's/"/\\"/g')
        # Position and length in seconds
        media_position=$(playerctl position 2>/dev/null | awk '{print int($1)}' || echo "0")
        media_length_us=$(playerctl metadata mpris:length 2>/dev/null || echo "0")
        media_length=$((media_length_us / 1000000))
    fi
fi

if [ -z "$media_title" ]; then media_title="Nothing playing"; fi
if [ -z "$media_artist" ]; then media_artist="Idle"; fi
if [ -z "$media_source" ]; then media_source="None"; fi

# Fetch CPU and GPU names dynamically
cpu_name=$(grep -m1 "model name" /proc/cpuinfo | cut -d: -f2 | xargs)
if [ -z "$cpu_name" ]; then cpu_name="Generic CPU"; fi

gpu_name=$(lspci | grep -i 'vga\|3d\|display' | cut -d: -f3 | head -n1 | sed 's/ (rev .*//' | xargs)
if [ -z "$gpu_name" ]; then gpu_name="Generic GPU"; fi

# Fetch OS and Desktop info dynamically
os_name=$(grep -m1 '^NAME=' /etc/os-release 2>/dev/null | sed 's/^NAME=//;s/^"//;s/"$//' | xargs)
if [ -z "$os_name" ]; then os_name="Linux"; fi

wm_name="$XDG_CURRENT_DESKTOP"
if [ -z "$wm_name" ]; then wm_name=$(echo "$DESKTOP_SESSION" | xargs); fi
if [ -z "$wm_name" ]; then wm_name="Unknown"; fi

host_name=$(hostname 2>/dev/null || cat /etc/hostname 2>/dev/null)
if [ -z "$host_name" ]; then host_name="linux"; fi

# Fetch Weather info (lightweight, cached-friendly)
weather_raw=$(curl -sf --max-time 2 "wttr.in/?format=%t|%C" 2>/dev/null)
if [ -n "$weather_raw" ]; then
    weather_temp=$(echo "$weather_raw" | cut -d'|' -f1 | tr -d '+' | xargs)
    weather_desc=$(echo "$weather_raw" | cut -d'|' -f2 | xargs | sed 's/"/\\"/g')
else
    weather_temp="--°C"
    weather_desc="Unknown"
fi

# Print as clean JSON
echo "{\"wifi\":\"$wifi\",\"ip_addr\":\"$ip_addr\",\"bat_cap\":$bat_cap,\"bat_status\":\"$bat_status\",\"vol\":$vol,\"muted\":$muted,\"brightness\":$bright_pct,\"ram\":$ram,\"ram_detail\":\"$ram_detail\",\"cpu\":$cpu,\"cpu_temp\":$cpu_temp,\"uptime\":\"$uptime_info\",\"media_title\":\"$media_title\",\"media_artist\":\"$media_artist\",\"media_status\":\"$media_status\",\"media_source\":\"$media_source\",\"media_position\":$media_position,\"media_length\":$media_length,\"cpu_name\":\"$cpu_name\",\"gpu_name\":\"$gpu_name\",\"os_name\":\"$os_name\",\"wm_name\":\"$wm_name\",\"host_name\":\"$host_name\",\"weather_temp\":\"$weather_temp\",\"weather_desc\":\"$weather_desc\"}"
