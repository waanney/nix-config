# ROS 2 Jazzy — dùng nix-ros-overlay (native NixOS packages)
# Overlay được apply tại đây, chỉ ảnh hưởng đến host newton
{
  inputs,
  pkgs,
  ...
}: {
  # Apply nix-ros-overlay vào nixpkgs của newton
  nixpkgs.overlays = [inputs.nix-ros-overlay.overlays.default];

  environment.systemPackages = with pkgs.rosPackages.jazzy; [
    # ── Core ROS 2 ──────────────────────────────────────────────────────────
    ros-core          # minimal runtime
    ros-base          # base tools + ament + colcon
    ros-dev-tools     # colcon, rosdep, bloom, v.v.

    # ── Thường dùng ─────────────────────────────────────────────────────────
    rviz2             # 3D visualizer
    rqt               # GUI plugin framework
    rqt-graph         # visualize node graph
    rqt-topic         # monitor topics
    plotjuggler-ros   # time-series plotter

    # ── Navigation / SLAM ───────────────────────────────────────────────────
    nav2-bringup      # Navigation2 stack
    slam-toolbox      # 2D SLAM

    # ── Sensor / Hardware ───────────────────────────────────────────────────
    ros2-control       # ros2_control framework
    ros2-controllers   # controller library
    joint-state-publisher-gui

    # ── Simulation ──────────────────────────────────────────────────────────
    # Gazebo Harmonic (tương thích Jazzy) — dùng gz-sim
    # Isaac Sim cài qua pip / AppImage riêng
  ];

  # rosdep database (cần cho colcon build với external packages)
  environment.etc."ros/rosdep/sources.list.d/20-default.list".text = ''
    yaml https://raw.githubusercontent.com/ros/rosdistro/master/rosdep/osx-homebrew.yaml osx
    yaml https://raw.githubusercontent.com/ros/rosdistro/master/rosdep/base.yaml
    yaml https://raw.githubusercontent.com/ros/rosdistro/master/rosdep/python.yaml
    yaml https://raw.githubusercontent.com/ros/rosdistro/master/rosdep/ruby.yaml
    gbpdistro https://raw.githubusercontent.com/ros/rosdistro/master/releases/fuerte.yaml fuerte
  '';
}
