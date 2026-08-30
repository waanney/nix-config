{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./lua/plugins
    ./lua/vim-options.nix
  ];

  home.packages = with pkgs; [
    # ... giữ nguyên danh sách các package của bạn ...
    wl-clipboard
    gh
    fd
    wget
    nodejs
    ripgrep
    gcc
    tree-sitter
    cargo
    rustc
    lua51Packages.jsregexp
    python311Packages.latexcodec
    clang-tools
    lua-language-server
    stylua
    nil
    pyright
    typescript-language-server
    tailwindcss-language-server
    jdt-language-server
    rust-analyzer
    texlab
    zathura
    neovim-remote
    prettierd
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Sửa lỗi cảnh báo Python/Ruby
    withPython3 = false;
    withRuby = false;

    # Chuyển nội dung init.lua vào đây
    initLua = ''
      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      if not (vim.uv or vim.loop).fs_stat(lazypath) then
        vim.fn.system({
          "git",
          "clone",
          "--filter=blob:none",
          "https://github.com/folke/lazy.nvim.git",
          "--branch=stable",
          lazypath,
        })
      end
      vim.opt.rtp:prepend(lazypath)

      require("vim-options")
      require("lazy").setup("plugins", {
        rocks = { enabled = false },
        performance = {
          reset_packpath = false,
          rtp = { reset = false },
        },
      })
    '';
  };

  # XOÁ HOẶC COMMENT ĐOẠN NÀY ĐI
  # home.file.".config/nvim/init.lua".text = ...
}
