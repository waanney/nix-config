{pkgs, ...}: {
  services.mysql = {
    enable = true;
    package = pkgs.mysql84;
    settings = {
      mysqld = {
        # Optimize memory usage for dev workstation (~80MB instead of ~500MB)
        performance_schema = "OFF";
        innodb_buffer_pool_size = "64M";
        innodb_log_buffer_size = "8M";
        max_connections = "50";
        table_open_cache = "400";
      };
    };
  };
}
