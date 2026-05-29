{
  description = "Cybersecurity development shell with pentesting tools and Pwntools";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    shell = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        nmap
        metasploit
        burpsuite
        hashcat
        john
        binwalk
        gobuster
        ffuf
        sqlmap
        termshark
        radare2
        python312
        python312Packages.pwntools
        python312Packages.pip
        neovim
        nushell
        starship
      ];
      shellHook = ''
        export SHELL=$(which nu)
        echo "Welcome to the Cybersecurity development environment"
      '';
    };
  in {
    devShells.${system} = {
      default = shell;
      cybersecurity-dev = shell;
    };
  };
}
