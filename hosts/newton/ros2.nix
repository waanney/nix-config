# ROS 2 Jazzy — dùng nix-ros-overlay (native NixOS packages)
# Overlay được apply tại đây, chỉ ảnh hưởng đến host newton
{
  config,
  inputs,
  pkgs,
  ...
}: {
  # Apply nix-ros-overlay vào nixpkgs của newton
  nixpkgs.overlays = [
    inputs.nix-ros-overlay.overlays.default
    (final: prev: {
      rosPackages =
        prev.rosPackages
        // {
          # Use the scoped overlay so all dependent ROS packages (including
          # Nav2) receive the patched vendor package.
          jazzy = prev.rosPackages.jazzy.overrideScope (_finalRos: prevRos: {
            # DART used by Gazebo emits a C++20 deprecation warning with GCC 16.
            # The vendored build treats it as an error by default.
            "gz-dartsim-vendor" = prevRos."gz-dartsim-vendor".overrideAttrs (old: {
              NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or "") + " -Wno-error=deprecated";
            });
            "nav2-navfn-planner" = prevRos."nav2-navfn-planner".overrideAttrs (old: {
              NIX_CFLAGS_COMPILE = (old.NIX_CFLAGS_COMPILE or "") + " -Wno-error=unused-but-set-variable";
            });
          });
        };
    })
  ];

  # ROS metapackages do not expose their dependency executables on their own.
  # buildEnv collects them and wraps tools with the ROS/Python search paths.
  environment.systemPackages = [config.system.build.rosEnv];
  system.build.rosEnv = with pkgs.rosPackages.jazzy;
    (buildEnv {
      paths = [
        # ── Core ROS 2 ──────────────────────────────────────────────────────────
        ros-core # minimal runtime
        ros-base # base tools + ament + colcon

        # ── Thường dùng ─────────────────────────────────────────────────────────
        rviz2 # 3D visualizer
        rqt # GUI plugin framework
        rqt-graph # visualize node graph
        rqt-topic # monitor topics
        # plotjuggler-ros is currently incompatible with the Abseil/Protobuf
        # versions in the pinned nixpkgs revision.

        # ── Navigation / SLAM ───────────────────────────────────────────────────
        nav2-bringup # Navigation2 stack
        slam-toolbox # 2D SLAM

        # ── Sensor / Hardware ───────────────────────────────────────────────────
        ros2-control # ros2_control framework
        ros2-controllers # controller library
        joint-state-publisher-gui

        # ── Simulation ──────────────────────────────────────────────────────────
        # Gazebo Harmonic (tương thích Jazzy) — dùng gz-sim
        # Isaac Sim cài qua pip / AppImage riêng
      ];
    }).overrideAttrs (old: {
      postFixup =
        (old.postFixup or "")
        + ''
          # Keep discovery local by default and avoid Qt/Ogre Wayland issues.
          # Explicit environment overrides still allow remote Gazebo sessions.
          # Isolate the GUI from qt5ct/Kvantum and GNOME palette overrides.
          # QT_STYLE_OVERRIDE also overrides the Controls 2 config (Fusion's
          # 13px sliders collapse Gazebo's joint rows); leave it unset here.
          # Use a Controls 2 config: the STYLE environment variable also reaches
          # Controls 1, which does not implement Material and falls back badly.
          wrapProgram "$out/bin/gz" \
            --set-default GZ_IP 127.0.0.1 \
            --set-default QT_QPA_PLATFORM xcb \
            --set QT_QPA_PLATFORMTHEME generic \
            --unset QT_STYLE_OVERRIDE \
            --prefix XDG_DATA_DIRS : ${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name} \
            --unset QT_QUICK_CONTROLS_STYLE \
            --set QT_QUICK_CONTROLS_CONF ${pkgs.writeText "gazebo-qtquickcontrols2.conf" ''
            [Controls]
            Style=Material

            [Material]
            # Quick Start uses white surfaces; keep controls light as well.
            Theme=Light
            Primary=BlueGrey
            Accent=LightBlue
          ''} \
            --set QT_QUICK_CONTROLS_MATERIAL_THEME Light
        '';
    });

  # rosdep database (cần cho colcon build với external packages)
  environment.etc."ros/rosdep/sources.list.d/20-default.list".text = ''
    yaml https://raw.githubusercontent.com/ros/rosdistro/master/rosdep/osx-homebrew.yaml osx
    yaml https://raw.githubusercontent.com/ros/rosdistro/master/rosdep/base.yaml
    yaml https://raw.githubusercontent.com/ros/rosdistro/master/rosdep/python.yaml
    yaml https://raw.githubusercontent.com/ros/rosdistro/master/rosdep/ruby.yaml
    gbpdistro https://raw.githubusercontent.com/ros/rosdistro/master/releases/fuerte.yaml fuerte
  '';
}
