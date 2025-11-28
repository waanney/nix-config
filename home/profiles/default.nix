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
  };

  inherit (inputs.hm.lib) homeManagerConfiguration;

  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
in {
  _module.args = {inherit homeImports;};

  flake = {
    homeConfiguration = {
      "waanne_maclaurin" = homeManagerConfiguration {
        modules = homeImports."waanne@maclaurin";
        inherit pkgs extraSpecialArgs;
      };
    };
  };
}
