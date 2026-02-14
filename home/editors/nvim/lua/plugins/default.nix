
{
  imports = [
    # UI & Visual
    ./ui/colorscheme.nix
    ./ui/lualine.nix
    ./ui/bufferline.nix
    ./ui/indent-blankline.nix
    ./ui/colorizer.nix
    ./ui/animations.nix
    
    # Navigation & Search
    ./navigation/telescope.nix
    ./navigation/neo-tree.nix
    ./navigation/flash.nix
    
    # LSP & Diagnostics
    ./lsp/lsp-config.nix
    ./lsp/trouble.nix
    ./lsp/none-ls.nix
    
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
  ];
}
