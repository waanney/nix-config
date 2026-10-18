{
  self,
  inputs,
  homeImports,
  ...
}: {
  flake.nixosConfigurations = let
    # shorten paths
    inherit (inputs.nixpkgs.lib) nixosSystem;
    mod = "${self}/system";

    # get the basic config to build on top of
    inherit (import "${self}/system") laptop desktop_nvidia;

    # get these into the module system
    specialArgs = {inherit inputs self;};
  in {
    maclaurin = nixosSystem {
      inherit specialArgs;
      modules =
        laptop
        ++ [
          ./maclaurin
          "${mod}/services/gnome-services.nix"
          "${mod}/services/location.nix"
          {
            home-manager = {
              users.waanne.imports =
                homeImports."waanne@maclaurin";
              extraSpecialArgs = specialArgs;
            };
          }

          inputs.agenix.nixosModules.default
          inputs.chaotic.nixosModules.default
        ];
    };

    newton = nixosSystem {
      inherit specialArgs;
      modules =
        desktop_nvidia
        ++ [
          ./newton
          "${mod}/services/gnome-services.nix"
          "${mod}/services/location.nix"
          {
            home-manager = {
              users.waanne.imports =
                homeImports."waanne@newton";
              extraSpecialArgs = specialArgs;
            };
          }

          inputs.agenix.nixosModules.default
          inputs.chaotic.nixosModules.default
        ];
    };
  };
}
