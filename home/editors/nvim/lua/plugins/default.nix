{
  imports = [
    # UI & Visual
    ./ui/colorscheme.nix
    ./ui/lualine.nix
    ./ui/bufferline.nix
    ./ui/indent-blankline.nix
    ./ui/colorizer.nix
    # ./ui/animations.nix # Tắt để tối ưu CPU & tránh lag con trỏ


    # Navigation & Search
    ./navigation/telescope.nix
    ./navigation/oil.nix
    ./navigation/flash.nix

    # LSP & Diagnostics
    ./lsp/lsp-config.nix
    ./lsp/trouble.nix
    ./lsp/conform.nix

    # Editing & Completion
    ./editing/completions.nix
    ./editing/comment.nix
    ./editing/autoclose.nix
    ./editing/treesitter.nix

    # Language Specific
    ./languages/latex.nix
    ./languages/markdown.nix

    # Git Integration
    ./git/gitsigns.nix

    # Utilities
    ./utils/which-key.nix
    ./utils/obsidian.nix
  ];
}
