{
  description = "LaTeX editing shell with TeX Live, latexmk, and TexLab";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    shell = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        (texlive.combine {
          inherit (texlive) scheme-small latexmk biblatex biber fontspec xetex luatex;
        })
        texlab
        zathura
        ghostscript
        python312Packages.pygments
      ];
      shellHook = ''
        export SHELL=$(which nu)
        echo "LaTeX environment ready (texlab, latexmk, zathura)"
      '';
    };
  in {
    devShells.${system} = {
      default = shell;
      latex-dev = shell;  -- Allow nix develop .#latex-dev in template directory
    };
  };
}
