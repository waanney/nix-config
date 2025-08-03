

{ pkgs, ... }:
{
  #packages for lsp, linter - nvim
  home.packages = with pkgs; [
  ];

  programs.zsh = {
    enable = true;

    initContent = ''
      eval "$(starship init zsh)"
    '';

    shellAliases = {
      gs = "git status";
      gd = "git diff";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gpu = "git pull";
      gl = "git log";
      gb = "git branch";
      gi = "git init";
      gcl = "git clone";
    };
  };
}
