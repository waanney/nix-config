# This file is NOT imported into your NixOS config.
# It is only used by the `agenix` CLI to know which keys can decrypt which secrets.
let
  # System SSH host key (from /etc/ssh/ssh_host_ed25519_key.pub)
  maclaurin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINaLvkqrx6ZhTKonttsoGSEfXxBXiDn1sSXJK3NxuuSv root@maclaurin";

  systems = [maclaurin];
in {
  "oracle-pwd.age".publicKeys = systems;
}
