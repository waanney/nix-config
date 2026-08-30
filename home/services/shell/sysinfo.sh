#!/usr/bin/env bash

# 1. Fetch WiFi SSID
wifi=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2 | head -n1)
if [ -z "$wifi" ]; then wifi="Disconnected"; fi

# 2. Fetch IP Address
ip_addr=$(hostname -I 2>/dev/null | awk '{print $1}')
if [ -z "$ip_addr" ]; then ip_addr="127.0.0.1"; fi

# 3. Fetch Battery Info
bat_cap=$(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null || cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "100")
bat_status=$(cat /sys/class/power_supply/BAT1/status 2>/dev/null || cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo "Unknown")

# 4. Fetch Volume Info
vol_info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null || echo "Volume: 0.0")
vol=$(echo "$vol_info" | awk '{print int($2*100)}')
[ -z "$vol" ] && vol=0
muted=$(echo "$vol_info" | grep -q "MUTED" && echo "true" || echo "false")

# 5. Fetch Brightness
bright_pct=$(brightnessctl -m 2>/dev/null | cut -d, -f4 | tr -d '%' || echo "100")
[ -z "$bright_pct" ] && bright_pct="100"

# 6. Fetch Memory usage (RAM)
read -r ram ram_detail < <(free -h 2>/dev/null | awk '/Mem:/ {print int($3/$2*100), $3 " / " $2}' | tr -d 'i')
[ -z "$ram" ] && ram=0
[ -z "$ram_detail" ] && ram_detail="0 / 0"

# 7. Fast CPU calculation (sample over 0.05s from /proc/stat)
read -r prev_total prev_idle < <(awk '/^cpu / {print $2+$3+$4+$5+$6+$7+$8, $5+$6}' /proc/stat 2>/dev/null)
sleep 0.05
read -r curr_total curr_idle < <(awk '/^cpu / {print $2+$3+$4+$5+$6+$7+$8, $5+$6}' /proc/stat 2>/dev/null)
diff_total=$((curr_total - prev_total))
diff_idle=$((curr_idle - prev_idle))
if [ "$diff_total" -gt 0 ]; then
    cpu=$(( (diff_total - diff_idle) * 100 / diff_total ))
else
    cpu=0
fi

# CPU Temperature
cpu_temp=$(cat /sys/class/thermal/thermal_zone0/temp 2>/dev/null | awk '{print int($1/1000)}')
[ -z "$cpu_temp" ] && cpu_temp=0

# 8. Fetch Uptime
uptime_info=$(awk '{print int($1/3600) "h " int(($1%3600)/60) "m"}' /proc/uptime 2>/dev/null || echo "0h 0m")

# 9. Media Info (single fast playerctl call)
media_title="Nothing playing"
media_artist="Idle"
media_status="Stopped"
media_source="None"
media_position=0
media_length=0
if command -v playerctl >/dev/null 2>&1; then
    m_info=$(playerctl metadata --format '{{status}}|{{playerName}}|{{title}}|{{artist}}|{{position}}|{{mpris:length}}' 2>/dev/null)
    if [ -n "$m_info" ]; then
        IFS="|" read -r m_status m_source m_title m_artist m_pos_raw m_len_raw <<< "$m_info"
        [ -n "$m_status" ] && media_status="$m_status"
        [ -n "$m_source" ] && media_source=$(echo "$m_source" | sed 's/"/\\"/g')
        [ -n "$m_title" ] && media_title=$(echo "$m_title" | sed 's/"/\\"/g')
        [ -n "$m_artist" ] && media_artist=$(echo "$m_artist" | sed 's/"/\\"/g')
        if [ -n "$m_pos_raw" ] && [ "$m_pos_raw" != "0" ]; then
            media_position=$(awk -v p="$m_pos_raw" 'BEGIN {print int(p/1000000)}')
        fi
        if [ -n "$m_len_raw" ] && [ "$m_len_raw" != "0" ]; then
            media_length=$(awk -v l="$m_len_raw" 'BEGIN {print int(l/1000000)}')
        fi
    fi
fi

# 10. Static / Hardware Info (cached / fast)
cpu_name=$(grep -m1 "model name" /proc/cpuinfo 2>/dev/null | cut -d: -f2 | xargs | sed 's/"/\\"/g')
[ -z "$cpu_name" ] && cpu_name="Intel Core Ultra 7"

gpu_name="Intel Arc Graphics"
os_name="NixOS"
wm_name="${XDG_CURRENT_DESKTOP:-niri}"
host_name="$(hostname 2>/dev/null || cat /etc/hostname 2>/dev/null || echo 'linux')"

# 11. Weather Info (cached, async background refresh every 15 min)
weather_cache="/tmp/quickshell_weather.txt"
if [ ! -f "$weather_cache" ] || [ $(($(date +%s) - $(stat -c %Y "$weather_cache" 2>/dev/null || echo 0))) -gt 900 ]; then
    (curl -sf --max-time 2 "wttr.in/?format=%t|%C" > "$weather_cache.tmp" 2>/dev/null && mv "$weather_cache.tmp" "$weather_cache") &
fi
if [ -f "$weather_cache" ]; then
    weather_raw=$(cat "$weather_cache")
    weather_temp=$(echo "$weather_raw" | cut -d'|' -f1 | tr -d '+' | xargs)
    weather_desc=$(echo "$weather_raw" | cut -d'|' -f2 | xargs | sed 's/"/\\"/g')
else
    weather_temp="--°C"
    weather_desc="Updating..."
fi

# Print clean JSON
echo "{\"wifi\":\"$wifi\",\"ip_addr\":\"$ip_addr\",\"bat_cap\":$bat_cap,\"bat_status\":\"$bat_status\",\"vol\":$vol,\"muted\":$muted,\"brightness\":$bright_pct,\"ram\":$ram,\"ram_detail\":\"$ram_detail\",\"cpu\":$cpu,\"cpu_temp\":$cpu_temp,\"uptime\":\"$uptime_info\",\"media_title\":\"$media_title\",\"media_artist\":\"$media_artist\",\"media_status\":\"$media_status\",\"media_source\":\"$media_source\",\"media_position\":$media_position,\"media_length\":$media_length,\"cpu_name\":\"$cpu_name\",\"gpu_name\":\"$gpu_name\",\"os_name\":\"$os_name\",\"wm_name\":\"$wm_name\",\"host_name\":\"$host_name\",\"weather_temp\":\"$weather_temp\",\"weather_desc\":\"$weather_desc\"}"
