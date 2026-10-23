{
  config,
  lib,
  ...
}: {
  options.services.oracleDatabase.enable =
    lib.mkEnableOption "the Oracle database container and its agenix password secret";

  config = lib.mkMerge [
    {
      virtualisation.docker.enable = true;
      virtualisation.oci-containers.backend = "docker";
    }
    (lib.mkIf config.services.oracleDatabase.enable {
      age.secrets.oracle-pwd.file = ../../secrets/oracle-pwd.age;

      virtualisation.oci-containers.containers."oracle-db" = {
        image = "container-registry.oracle.com/database/free:latest";
        ports = [
          "1521:1521"
          "5500:5500"
        ];
        environment = {
          ORACLE_PWD_FILE = "/run/secrets/oracle-pwd";
        };
        volumes = [
          "${config.age.secrets.oracle-pwd.path}:/run/secrets/oracle-pwd:ro"
        ];
        autoStart = false;
      };
    })
  ];
}
