
{ config, pkgs, ... }:
{
  #packages for lsp, linter - nvim
  home.packages = with pkgs; [
  ];

  programs.git = {
    enable = true;
    #user
    userName = "waanney";
    userEmail = "work.buiminhquan@gmail.com";
    extraConfig = {

      init = {
      defaultBranch = "main";
      };

      status = {
        branch = true;
        showStash = true;
        showUntrackedFiles = "all";
      };

      credential = {
        helper = "!gh auth git-credential";
      };

      core = {
        compression = 9;
        preloadindex = true;
      };

      commit = {
        template = "${config.home.homeDirectory}/.config/git/commit-template.txt";
      };
      
    };
  };

  home.file.".config/git/commit-template.txt".text = ''
# feat: 
# 
# fix:
# hotfix:
# refractor: 
#
# style:
# ci/cd: 
# deploy:
  '';
}
