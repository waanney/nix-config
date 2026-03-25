{ pkgs, ... }: # Ensure pkgs is available in your arguments

{
  virtualisation.docker.enable = true;

  # programs.adb.enable = true; # REMOVE OR DELETE THIS LINE

  # To keep using the 'adb' command, add the tools package here:
  # environment.systemPackages = [
  #   pkgs.android-tools
  # ];

  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers = "oracle-db" = {
    image = "container-registry.oracle.com/database/free:latest";
    ports = [
      "1521:1521"
      "5500:5500"
    ];
    environment = {
      ORACLE_PWD = "MatKhauBaoMatCuaBan123";
    };
    autoStart = true;
  };
}
