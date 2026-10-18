{
  self,
  inputs,
  ...
}: let
  # get these into the module system
  extraSpecialArgs = {inherit inputs self;};

  homeImports = {
    "waanne@maclaurin" = [
      ../.
      ./maclaurin
    ];

    "waanne@newton" = [
      ../.
      ./newton
    ];
  };

  inherit (inputs.hm.lib) homeManagerConfiguration;

  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in {
  _module.args = {inherit homeImports;};

  flake = {
    homeConfigurations = {
      "waanne@maclaurin" = homeManagerConfiguration {
        modules = homeImports."waanne@maclaurin";
        inherit pkgs extraSpecialArgs;
      };
      "waanne_maclaurin" = homeManagerConfiguration {
        modules = homeImports."waanne@maclaurin";
        inherit pkgs extraSpecialArgs;
      };
      "waanne" = homeManagerConfiguration {
        modules = homeImports."waanne@maclaurin";
        inherit pkgs extraSpecialArgs;
      };

      "waanne@newton" = homeManagerConfiguration {
        modules = homeImports."waanne@newton";
        inherit pkgs extraSpecialArgs;
      };
    };
  };
}
