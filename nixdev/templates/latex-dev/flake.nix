{
  description = "LaTeX editing shell with TeX Live, Vietnamese support, latexmk, and TexLab";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {nixpkgs, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    shell = pkgs.mkShell {
      nativeBuildInputs = with pkgs; [
        (texliveSmall.withPackages (ps:
          with ps; [
            collection-latexrecommended
            collection-mathscience
            collection-fontsrecommended
            latexmk
            biblatex
            biber
            fontspec
            xetex
            luatex
            vntex
            babel-vietnamese
            titlesec
            enumitem
            float
            caption
            wrapfig
            tcolorbox
            pgf
            tikz-cd
          ]))
        texlab
        zathura
        ghostscript
        python312Packages.pygments
      ];
      shellHook = ''
        echo "LaTeX development environment ready (TeX Live with Vietnamese support, latexmk, texlab)"
      '';
    };
  in {
    devShells.${system} = {
      default = shell;
      latex-dev = shell;
    };
  };
}
