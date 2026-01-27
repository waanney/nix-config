{
  pkgs,
  lib,
  config,
  ...
}: let
  lock = "${pkgs.systemd}/bin/loginctl lock-session";

  # Thay brillo bằng brightnessctl
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";

  # timeout sau 5 phút (300 giây)
  timeout = 300;
in {
  services.hypridle = {
    enable = true;

    settings = {
      general.lock_cmd = lib.getExe config.programs.hyprlock.package;

      listener = [
        {
          timeout = timeout - 10; # 290 giây
          # Giảm độ sáng xuống 10% (brightnessctl không có -O/-I nên ta set trực tiếp)
          on-timeout = "${brightnessctl} set 10%";
          # Trả lại độ sáng 100% (hoặc mức bạn muốn) khi quay lại
          on-resume = "${brightnessctl} set 100%";
        }
        {
          inherit timeout;
        }
        {
          timeout = timeout + 10;
          on-timeout = lock;
        }
      ];
    };
  };

  systemd.user.services.hypridle.Unit.After = lib.mkForce "graphical-session.target";
}
