{
  description = "Rust development shell with rust-analyzer and common build deps";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        rustc
        cargo
        rustfmt
        clippy
        rust-analyzer
        neovim
        nushell
        starship
        pkg-config
        openssl
      ];
      shellHook = ''
        export SHELL=$(which nu)
        echo "Welcome to the Rust development environment"
      '';
    };
  };
}



