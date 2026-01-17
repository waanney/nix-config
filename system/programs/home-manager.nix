{ inputs, ... }: {
  imports = [
    inputs.hm.nixosModules.default
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    
    # Thêm dòng này để tự động sao lưu các file xung đột
    # Các file trùng sẽ được đổi đuôi thành .backup
    backupFileExtension = "backup";
  };
}
