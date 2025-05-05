# My Dotfiles Setup

## Introduction

Hi 😂

Every day I use Vim, and I feel like I learn something new daily. So please don't be surprised or judge why this repository has so many commits.

## Main Tools


- **Neovim** (code editor)
- **Hyprland** (tiling window manager for Wayland)
- **Kitty** (terminal emulator)
- **Starship** (replaces oh-my-zsh)
- **Waybar** (customizable bar for Wayland)
- **Rofi** (launcher and file search)

## Installation Steps

### Clone the Repository
```bash
git clone https://github.com/waanney/dotfiles.git ~/dotfiles
```

### Set Up Configurations with Stow
```bash
cd ~/dotfiles
stow nvim
stow hyprland
stow starship
stow waybar
stow rofi
```

## Installing Required Tools

Please install the required tools manually based on your system's package manager. Here are some common commands:

For **NixOS**:
```bash
nix-env -iA nixpkgs.neovim nixpkgs.hyprland nixpkgs.kitty nixpkgs.starship nixpkgs.waybar nixpkgs.rofi
```

For **Arch Linux** (using pacman):
```bash
sudo pacman -S neovim hyprland kitty starship waybar rofi
```

For **Debian/Ubuntu** (using apt):
```bash
sudo apt install neovim kitty rofi
```
*(Hyprland and Waybar may require additional setup on Debian-based systems.)*

## Additional Notes

- **Ensure you have Nerd Fonts installed** for proper icon rendering.
- **Customize Waybar** and **Hyprland** based on your preferences.
- **Use Starship** to replace oh-my-zsh for a faster shell prompt.

Let me know if you need any modifications! 🚀
