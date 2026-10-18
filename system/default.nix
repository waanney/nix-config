let
  # Modules chung cho mọi desktop (không bao gồm GPU driver)
  desktop_base = [
    ./core/boot.nix
    ./core/default.nix

    ./hardware/fwupd.nix

    ./network/default.nix
    ./network/avahi.nix

    ./programs

    ./services
    ./services/ananicy.nix
    ./services/docker.nix
    ./services/greetd.nix
    ./services/pipewire.nix
    ./services/tailscale.nix
    ./services/anydesk.nix
    ./services/mysql.nix
    ./services/postgresql.nix
    ./services/virtualbox.nix
  ];

  # Desktop thông thường (Intel/AMD integrated graphics)
  desktop =
    desktop_base
    ++ [./hardware/graphics.nix];

  # Laptop = desktop + bluetooth + backlight + power
  laptop =
    desktop
    ++ [
      ./hardware/bluetooth.nix

      ./services/backlight.nix
      ./services/power.nix
    ];

  # Desktop NVIDIA: dùng nvidia.nix thay graphics.nix chung
  # Dành cho PC có GPU NVIDIA (RTX 5080, v.v.)
  desktop_nvidia =
    desktop_base
    ++ [
      ./hardware/nvidia.nix
      ./hardware/bluetooth.nix # B760M GAMING PLUS WIFI có BT onboard
    ];
in {
  inherit desktop laptop desktop_nvidia;
}
