{
  description = "A simple NixOS flake";

  inputs = {
    zen-browser.url = "https://flakehub.com/f/kbwhodat/zen-browser/0.1.149";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.maclaurin = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit home-manager;};
      modules = [
        ./hosts/maclaurin/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.users.waanne = import ./home-manager/home.nix;
          home-manager.backupFileExtension = "backup";
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
  };
}
