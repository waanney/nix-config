{pkgs, ...}: let
  # ── Shared helpers (session_hash, get_tmux_option) ────────────────────
  helpersScript = ''
    # get_tmux_option <option-name> <default>
    get_tmux_option() {
      local value
      value="$(tmux show-option -gqv "$1" 2>/dev/null)"
      if [ -n "$value" ]; then printf '%s' "$value"; else printf '%s' "$2"; fi
    }

    # session_hash <string> — stable 8-char hash for session naming
    session_hash() {
      local out
      if command -v md5sum >/dev/null 2>&1; then
        out="$(printf '%s\n' "$1" | md5sum)"
      elif command -v md5 >/dev/null 2>&1; then
        out="$(printf '%s\n' "$1" | md5 -q)"
      else
        out="$(printf '%s\n' "$1" | shasum)"
      fi
      printf '%s' "''${out%% *}" | cut -c1-8
    }
  '';

  # ── tm-ai: launch / re-attach a per-agent per-project AI session ─────
  tmAi = pkgs.writeShellScriptBin "tm-ai" ''
    set -uo pipefail
    ${helpersScript}

    path="''${1:-$PWD}"
    agent="''${2:-agy}"

    case "$agent" in
      antigravity|antigravity-cli|agy) agent_cmd="agy" ;;
      *) agent_cmd="$agent" ;;
    esac

    prefix="$(get_tmux_option @ai_session_prefix 'ai-')"
    w="$(get_tmux_option @ai_popup_width '90%')"
    h="$(get_tmux_option @ai_popup_height '90%')"

    session="''${prefix}''${agent_cmd}-$(session_hash "$path")"

    tmux has-session -t "$session" 2>/dev/null \
      || tmux new-session -d -s "$session" -c "$path" "$agent_cmd"

    # Stash origin window + agent type on the session for the picker
    tmux set-option -t "$session" @ai_origin "''${3:-}" 2>/dev/null
    tmux set-option -t "$session" @ai_agent "$agent"       2>/dev/null
    tmux set-option -t "$session" @ai_path  "$path"        2>/dev/null

    tmux display-popup -w "$w" -h "$h" -E "tmux attach-session -t $session"
  '';

  # ── tm-ai-picker: fzf-based picker for all AI sessions ───────────────
  tmAiPicker = pkgs.writeShellScriptBin "tm-ai-picker" ''
    set -uo pipefail
    ${helpersScript}

    prefix="$(get_tmux_option @ai_session_prefix 'ai-')"

    # ── Agent → icon mapping ──
    agent_icon() {
      case "$1" in
        claude)                            printf '🟣' ;;
        antigravity|antigravity-cli|agy)   printf '🔵' ;;
        pi-coding-agent)                   printf '🟠' ;;
        gemini-cli)      printf '🟢' ;;
        codex)           printf '⚪' ;;
        opencode)        printf '🔶' ;;
        *)               printf '⬜' ;;
      esac
    }

    emit_rows() {
      local now s state at path agent icon_agent icon_state rank ago
      now=$(date +%s)
      tmux list-sessions -F '#{session_name}' 2>/dev/null \
        | grep "^''${prefix}" | while IFS= read -r s; do

        state=$(tmux show-options -qv -t "$s" @ai_state  2>/dev/null)
        at=$(tmux show-options -qv    -t "$s" @ai_state_at 2>/dev/null)
        agent=$(tmux show-options -qv  -t "$s" @ai_agent 2>/dev/null)
        path=$(tmux display-message -p -t "$s" '#{pane_current_path}' 2>/dev/null)

        icon_agent="$(agent_icon "$agent")"

        case "$state" in
          waiting) icon_state=$'\033[33m●\033[0m waiting' rank=0 ;; # yellow
          idle)    icon_state=$'\033[32m●\033[0m idle   ' rank=1 ;; # green
          working) icon_state=$'\033[31m●\033[0m working' rank=3 ;; # red
          *)       icon_state=$'\033[90m●\033[0m   ?    ' rank=2 ;; # grey
        esac

        if [ -n "$at" ]; then ago="$(( (now - at) / 60 ))m"; else ago='-'; fi
        # rank \t session \t agent-icon \t state-icon \t agent \t path \t age
        printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
          "$rank" "$s" "$icon_agent" "$icon_state" "$agent" "''${path/#$HOME/~}" "$ago"
      done | sort -n
    }

    # --list mode: used by fzf's reload binding
    [ "''${1:-}" = '--list' ] && { emit_rows; exit 0; }

    if ! command -v fzf >/dev/null 2>&1; then
      tmux display-message "tm-ai-picker: fzf is required"
      exit 0
    fi

    self="$(command -v tm-ai-picker)"
    sel=$(emit_rows | fzf --ansi --delimiter='\t' --with-nth=3,4,5,6,7 \
      --reverse --cycle \
      --header='AI Sessions · enter: jump · ctrl-x: kill · ctrl-r: refresh' \
      --preview="tmux capture-pane -ept {2}" --preview-window='right,62%,wrap' \
      --bind="ctrl-x:execute-silent(tmux kill-session -t {2})+reload($self --list)" \
      --bind="ctrl-r:reload($self --list)")

    [ -z "$sel" ] && exit 0
    target=$(printf '%s' "$sel" | cut -f2)

    # Move parent client to session's origin window, then resume in popup
    origin=$(tmux show-options -qv -t "$target" @ai_origin  2>/dev/null)
    parent=$(tmux show-options -gqv @ai_parent              2>/dev/null)
    [ -n "$origin" ] && [ -n "$parent" ] && \
      tmux switch-client -c "$parent" -t "$origin" 2>/dev/null

    tmux attach-session -t "$target"
  '';

  # ── tm-ai-list: opens the picker in a popup ──────────────────────────
  tmAiList = pkgs.writeShellScriptBin "tm-ai-list" ''
    set -uo pipefail
    ${helpersScript}

    # Stash triggering client so the picker can move it
    tmux set-option -g @ai_parent "''${1:-}"

    w="$(get_tmux_option @ai_popup_width '90%')"
    h="$(get_tmux_option @ai_popup_height '90%')"
    tmux display-popup -w "$w" -h "$h" -E "tm-ai-picker"
  '';

  # ── tm-ai-state: record session state (for hooks) ────────────────────
  tmAiState = pkgs.writeShellScriptBin "tm-ai-state" ''
    # Usage: tm-ai-state <working|waiting|idle>
    # Call from AI tool hooks. No-op outside tmux.
    [ -z "''${TMUX_PANE:-}" ] && exit 0

    session=$(tmux display-message -p -t "$TMUX_PANE" '#{session_name}' 2>/dev/null) || exit 0
    [ -z "$session" ] && exit 0

    tmux set-option -t "$session" @ai_state    "''${1:-idle}"
    tmux set-option -t "$session" @ai_state_at "$(date +%s)"
    exit 0
  '';
in {
  home.packages = with pkgs; [
    # AI CLI agents
    antigravity-cli
    claude-code
    pi-coding-agent
    codex

    # Dependencies
    fzf

    # Session manager scripts
    tmAi
    tmAiPicker
    tmAiList
    tmAiState
  ];
}
