{pkgs, ...}: {
  imports = [
    # Thêm cấu hình cho các coding agent CLI vào đây. Ví dụ:
    # ./aider.nix
    # ./claude-code.nix
  ];

  home.packages = with pkgs; [
    antigravity
    claude-code
    pi-coding-agent
    gemini-cli
    codex
  ];
}
