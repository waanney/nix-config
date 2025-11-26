{
  description = "A Nix flake for web and AI development with shared Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    # Import các dev shells từ folder shells/
    devShells.x86_64-linux.web-dev = import ./shells/web-dev.nix {inherit pkgs;};
    devShells.x86_64-linux.ai-dev = import ./shells/ai-dev.nix {inherit pkgs;};
    devShells.x86_64-linux.rust-dev = import ./shells/rust-dev.nix {inherit pkgs;};
    devShells.x86_64-linux.game-dev = import ./shells/game-dev.nix {inherit pkgs;};
  };
}

