{
  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    extraConfig = ''
      # Tự động copy vào clipboard hệ thống khi bôi đen bằng chuột
      set -s set-clipboard on
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "wl-copy"

      # Chọn AI Agent (Leader + a)
      bind-key a display-menu -T "Select AI Agent" \
        "Claude" c "display-popup -E -w 80% -h 80% 'tm-ai \"#(basename #{pane_current_path})\" \"#{pane_current_path}\" \"claude\"'" \
        "Antigravity" a "display-popup -E -w 80% -h 80% 'tm-ai \"#(basename #{pane_current_path})\" \"#{pane_current_path}\" \"antigravity\"'" \
        "PI Coding Agent" p "display-popup -E -w 80% -h 80% 'tm-ai \"#(basename #{pane_current_path})\" \"#{pane_current_path}\" \"pi-coding-agent\"'" \
        "Gemini" g "display-popup -E -w 80% -h 80% 'tm-ai \"#(basename #{pane_current_path})\" \"#{pane_current_path}\" \"gemini-cli\"'" \
        "Codex" x "display-popup -E -w 80% -h 80% 'tm-ai \"#(basename #{pane_current_path})\" \"#{pane_current_path}\" \"codex\"'"

      # Mở Lazygit (Leader + g)
      bind-key g display-popup -E -w 80% -h 80% "lazygit"

      # Cấu hình giao diện popup
      set -g popup-border-style "fg=#89b482"
      set -g popup-border-lines "rounded"
    '';
  };
}
