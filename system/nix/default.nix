{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./nh.nix
    ./nixpkgs.nix
    ./substituters.nix
  ];

  # we need git for flakes

  environment.systemPackages = with pkgs; [git];

  nix = let
    flakeInputs = lib.filterAttrs (_: v: lib.isType "flake" v) inputs;
  in {
    package = pkgs.lix;

    # pin the registry to avoid downloading and evaling a new nixpkgs version every time
    registry =
      (lib.mapAttrs (_: v: {flake = v;}) flakeInputs)
      // {
        dev.to = {
          type = "path";
          path = "/etc/nixos/nixdev";
        };
      };

    # set the path for channels compat
    nixPath = lib.mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      # Keep local builds within available memory. Large Nix derivations can
      # otherwise start one compiler per CPU and trigger the OOM killer.
      max-jobs = 2;
      cores = 2;
      experimental-features = ["nix-command" "flakes"];
      flake-registry = "/etc/nix/registry.json";

      # for direnv GC roots
      keep-derivations = true;
      keep-outputs = true;

      trusted-users = ["root" "@wheel"];
      accept-flake-config = false;
    };
  };
}
