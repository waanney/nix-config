{
  description = "A simple NixOS flake";

  inputs = {
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = { 
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, home-manager, zen-browser, ... } @inputs :
    let
      system = "x86_64-linux";
    in
      {
    nixosConfigurations.maclaurin = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs system;};
      modules = [ ./hosts/maclaurin/configuration.nix];
    };
  };
}
