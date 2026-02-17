{
  pkgs,
  lib,
  ...
}: let
  vaultPath = "/home/waanne/Documents/01_Vault";
  
  syncScript = pkgs.writeShellScript "obsidian-sync.sh" ''
    set -euo pipefail
    
    # Add git to path
    export PATH="${pkgs.git}/bin:$PATH"
    
    if [ ! -d "${vaultPath}" ]; then
      echo "Vault directory ${vaultPath} does not exist."
      exit 1
    fi

    cd "${vaultPath}"
    
    if [ ! -d ".git" ]; then
      echo "Not a git repository. Skipping sync."
      exit 1
    fi

    # Check for changes
    if [ -n "$(git status --porcelain)" ]; then
      echo "Changes detected. Syncing..."
      git add .
      git commit -m "Auto sync: $(date '+%Y-%m-%d %H:%M:%S')"
      git push
      echo "Sync completed successfully."
    else
      echo "No changes detected."
    fi
  '';
in {
  systemd.user.services.obsidian-sync = {
    Unit = {
      Description = "Obsidian Vault Auto Sync";
      After = ["network-online.target"];
      Wants = ["network-online.target"];
    };

    Service = {
      Type = "oneshot";
      ExecStart = syncScript;
      IOSchedulingClass = "idle";
      CPUSchedulingPolicy = "idle";
    };
  };

  systemd.user.timers.obsidian-sync = {
    Unit = {
      Description = "Schedule Obsidian Vault Auto Sync";
    };

    Timer = {
      OnCalendar = "*-*-* 20:00:00";
      Persistent = true;
      RandomizedDelaySec = "5m";
    };

    Install = {
      WantedBy = ["timers.target"];
    };
  };
}
