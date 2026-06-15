{
  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    extraConfig = ''
      # Tự động copy vào clipboard hệ thống khi bôi đen bằng chuột
      set -s set-clipboard on
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "wl-copy"

      # ── AI Session Manager ──────────────────────────────────────────────
      # Chọn AI Agent và launch (prefix + a) — popup menu
      bind-key a display-menu -T "Launch AI Agent" \
        "Claude"           c "run-shell \"tm-ai '#{pane_current_path}' 'claude'          '#{window_id}'\"" \
        "Antigravity"      a "run-shell \"tm-ai '#{pane_current_path}' 'antigravity'     '#{window_id}'\"" \
        "PI Coding Agent"  p "run-shell \"tm-ai '#{pane_current_path}' 'pi-coding-agent' '#{window_id}'\"" \
        "Gemini"           g "run-shell \"tm-ai '#{pane_current_path}' 'gemini-cli'      '#{window_id}'\"" \
        "Codex"            x "run-shell \"tm-ai '#{pane_current_path}' 'codex'           '#{window_id}'\""

      # Mở AI session picker (prefix + u) — fzf picker with live preview
      bind-key u run-shell "tm-ai-list '#{client_name}'"

      # Mở Lazygit (prefix + g)
      bind-key g display-popup -E -w 80% -h 80% "lazygit"

      # Cấu hình giao diện popup
      set -g popup-border-style "fg=#89b482"
      set -g popup-border-lines "rounded"

      # AI Session Manager options (có thể tuỳ chỉnh)
      # set -g @ai_session_prefix 'ai-'
      # set -g @ai_popup_width    '90%'
      # set -g @ai_popup_height   '90%'
    '';
  };
}
