{
  pkgs,
  lib,
  inputs,
  ...
}:
# lanzaboote config
# Đã loại bỏ cấu hình lanzaboote vì không còn sử dụng
# {
#   imports = [
#     inputs.lanzaboote.nixosModules.lanzaboote
#   ];
#
#   boot = {
#     lanzaboote = {
#       enable = true;
#       pkiBundle = "/var/lib/sbctl";
#     };
#
#     # we let lanzaboote install systemd-boot
#     loader.systemd-boot.enable = lib.mkForce false;
#   };
#
#   environment.systemPackages = [pkgs.sbctl];
# }
