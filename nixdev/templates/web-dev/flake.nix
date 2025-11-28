{
  description = "Web development shell with Node.js, Bun, and Tailwind LSP";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    devShells.${system}.default = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        nodejs
        bun
        yarn
        pnpm
        neovim
        nushell
        starship
        tailwindcss-language-server
      ];
      shellHook = ''
        export SHELL=$(which nu)
        echo "Welcome to the web development environment"
      '';
    };
  };
}



