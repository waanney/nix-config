{
  description = "Java development shell with JDK, Maven, and common build tools";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    shell = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        jdk21          # Java Development Kit 21 (LTS)
        maven          # Maven build tool
        gradle         # Gradle build tool
        jdt-language-server  # Java language server for IDE support
        neovim
        nushell
        starship
        git
      ];
      shellHook = ''
        export SHELL=$(which nu)
        echo "Welcome to the Java development environment"
        echo "Java version: $(java -version 2>&1 | head -n 1)"
        echo "Maven version: $(mvn -version | head -n 1)"
      '';
    };
  in {
    devShells.${system} = {
      default = shell;
      java-dev = shell;  # Allow nix develop .#java-dev in template directory
    };
  };
}
