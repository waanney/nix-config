{
  config,
  pkgs,
  ...
}: {
  # NVIDIA RTX 5080 (Blackwell) — proprietary open kernel module
  hardware.nvidia = {
    modesetting.enable = true;

    # Desktop PC: không cần power management tích cực
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # nvidia-open: khuyến nghị cho Turing trở lên (RTX 5080 là Blackwell)
    open = true;

    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Kích hoạt NVIDIA driver qua Xorg/Wayland
  services.xserver.videoDrivers = ["nvidia"];

  # OpenGL + Vulkan + CUDA packages
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Steam, Wine, v.v.
    extraPackages = with pkgs; [
      libva
      libva-vdpau-driver
      libvdpau-va-gl
      mesa

      # NVIDIA VAAPI (hardware video decode)
      nvidia-vaapi-driver

      # Vulkan
      vulkan-loader
      vulkan-validation-layers
      vulkan-tools
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  # CUDA toolchain + GPU monitoring
  environment.systemPackages = with pkgs; [
    cudaPackages.cudatoolkit
    nvtopPackages.nvidia
  ];
}
