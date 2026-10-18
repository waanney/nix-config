#!/usr/bin/env bash
set -euo pipefail

VAULT_PATH="$HOME/Documents/01_Vault"
APP_ID="vault-ai"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/vault-ai"
STATE_FILE="$STATE_DIR/last_tool"

if [ ! -d "$VAULT_PATH" ]; then
    notify-send "Vault AI" "Thư mục $VAULT_PATH không tồn tại!" -u critical 2>/dev/null || true
    exit 1
fi
mkdir -p "$STATE_DIR"

MODE="${1:-}"

# Detect existing window with app_id == "vault-ai"
JAQ_BIN="jq"
if command -v jaq >/dev/null 2>&1; then
    JAQ_BIN="jaq"
fi

WINDOW_INFO=$(niri msg -j windows 2>/dev/null | $JAQ_BIN -r ".[] | select(.app_id == \"$APP_ID\") | \"\(.id) \(.is_focused)\"" | head -n 1 || true)
WINDOW_ID=""
IS_FOCUSED="false"

if [ -n "$WINDOW_INFO" ]; then
    WINDOW_ID=$(echo "$WINDOW_INFO" | awk '{print $1}')
    IS_FOCUSED=$(echo "$WINDOW_INFO" | awk '{print $2}')
fi

# Nếu bấm Mod+A thông thường (không phải --menu) và cửa sổ đã mở
if [ "$MODE" != "--menu" ] && [ -n "$WINDOW_ID" ]; then
    if [ "$IS_FOCUSED" = "true" ]; then
        # Đang focus -> toggle đóng (chỉ detach khỏi tmux, session vẫn giữ nguyên)
        niri msg action close-window
    else
        # Chưa focus -> focus ngay cửa sổ AI
        niri msg action focus-window --id "$WINDOW_ID"
    fi
    exit 0
fi

# Hiển thị menu Rofi để chọn công cụ AI
last_tool=""
if [ -f "$STATE_FILE" ]; then
    last_tool=$(cat "$STATE_FILE" 2>/dev/null || true)
fi

# Danh sách cấu hình: Label | Command | Session Name
declare -a RAW_TOOLS=(
    "󰚩 Claude Code|claude|vault-claude"
    "󰚩 OpenAI Codex|codex|vault-codex"
    "󰚩 Antigravity (agy)|agy|vault-agy"
)

declare -a FILTERED_TOOLS=()
for item in "${RAW_TOOLS[@]}"; do
    IFS="|" read -r label cmd session <<< "$item"
    if command -v "$cmd" >/dev/null 2>&1; then
        FILTERED_TOOLS+=("$item")
    fi
done

if [ ${#FILTERED_TOOLS[@]} -eq 0 ]; then
    notify-send "Vault AI" "Không tìm thấy công cụ AI nào (claude, codex, agy)!" -u critical 2>/dev/null || true
    exit 1
fi

# Sắp xếp để công cụ dùng gần nhất hiển thị đầu tiên
declare -a SORTED_LABELS=()
for item in "${FILTERED_TOOLS[@]}"; do
    IFS="|" read -r label cmd session <<< "$item"
    if [ "$cmd" = "$last_tool" ]; then
        SORTED_LABELS=("$label" "${SORTED_LABELS[@]}")
    else
        SORTED_LABELS+=("$label")
    fi
done

MENU_INPUT=$(printf "%s\n" "${SORTED_LABELS[@]}")
CHOSEN_LABEL=$(echo "$MENU_INPUT" | rofi -dmenu -i -p "󰚩 Chọn AI Assistant" 2>/dev/null || true)

if [ -z "$CHOSEN_LABEL" ]; then
    exit 0
fi

CHOSEN_CMD=""
CHOSEN_SESSION=""
for item in "${FILTERED_TOOLS[@]}"; do
    IFS="|" read -r label cmd session <<< "$item"
    if [ "$label" = "$CHOSEN_LABEL" ]; then
        CHOSEN_CMD="$cmd"
        CHOSEN_SESSION="$session"
        break
    fi
done

if [ -z "$CHOSEN_CMD" ]; then
    exit 0
fi

echo "$CHOSEN_CMD" > "$STATE_FILE"

# Nếu cửa sổ đang mở sẵn (gọi từ --menu), switch sang session mới ngay trong cửa sổ hiện tại
if [ -n "$WINDOW_ID" ]; then
    if ! tmux has-session -t "$CHOSEN_SESSION" 2>/dev/null; then
        tmux new-session -d -s "$CHOSEN_SESSION" -c "$VAULT_PATH" "$CHOSEN_CMD"
    fi
    CLIENT=$(tmux list-clients -F "#{client_name}" | head -n 1 || true)
    if [ -n "$CLIENT" ]; then
        tmux switch-client -c "$CLIENT" -t "$CHOSEN_SESSION"
    fi
    niri msg action focus-window --id "$WINDOW_ID"
    exit 0
fi

# Nếu chưa có cửa sổ, mở WezTerm floating với session đã chọn
exec wezterm start \
    --always-new-process \
    --class "$APP_ID" \
    --cwd "$VAULT_PATH" \
    -- tmux new-session -A -s "$CHOSEN_SESSION" "$CHOSEN_CMD"
