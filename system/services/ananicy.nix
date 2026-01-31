{ pkgs, ... }: {
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    
    # Sử dụng package từ chaotic-nyx (thường là ananicy-rules-cachyos)
    # Bỏ hậu tố _git để tránh cái gitOverride bị lỗi kia
    rulesProvider = pkgs.ananicy-rules-cachyos.overrideAttrs (prevAttrs: {
      patches = (prevAttrs.patches or []) ++ [
        (pkgs.fetchpatch {
          url = "https://github.com/CachyOS/ananicy-rules/commit/5459ed81c0e006547b4f3a3bc40c00d31ad50aa9.patch";
          revert = true;
          hash = "sha256-vc6FDwsAA6p5S6fR1FSdIRC1kCx3wGoeNarG8uEY2xM=";
        })
      ];
    });
  };
}
