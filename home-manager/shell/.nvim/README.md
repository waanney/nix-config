# My NeoVim Configuration for Web Development and C++

This configuration is designed to enhance your NeoVim experience for web development and C++ programming. It provides features like Language Server Protocol (LSP) support, autocompletion, syntax highlighting, window layout management, and notifications.

**Screenshot**

![Screenshot 2025-01-26 200108](https://github.com/user-attachments/assets/609f9244-1fb0-4b23-84ad-ce69082dcdcf)


**Features**

* **LSP Support:** Enjoy seamless language support for JavaScript, TypeScript, and C++ with LSP servers.
* **Autocompletion:** Get intelligent code completion suggestions using cmp-nvim.
* **Syntax Highlighting:** Benefit from beautiful and accurate syntax highlighting powered by treesitter.
* **Window Layouts:** Manage your workspace efficiently with edgy.nvim for customizable window layouts.
* **Notifications and Command Line:** Stay informed and interact with NeoVim using Noice for notifications and a command line interface.

**Requirements**

* **NeoVim >= 0.9.0 (built with LuaJIT):** Ensure you have a recent NeoVim version compiled with LuaJIT for optimal performance.
* **Git >= 2.19.0 (for partial clones):** Make sure you have Git installed with support for partial clones.
* **Nerd Font (v3.0 or greater) (optional):** While not mandatory, a Nerd Font enhances the visual experience with icons.
* **C Compiler for nvim-treesitter:** Refer to the nvim-treesitter documentation for instructions on installing a C compiler if needed.

**Installation**

**Note:** This configuration primarily uses LazyVim as the package manager. However, LazyVim's setup is automatically handled within `init.lua`, so you don't need to worry about manual configuration.

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/waanney/nvim-config.git ~/.config/nvim
   ```
  another path:

  
  ```bash
  git clone https://github.com/waanney/nvim-config.git /path/to/nvim/config
  ```
2. **Install Packages:**

    LazyVim typically handles package installation automatically during startup. However, if you encounter issues, you can manually trigger LazyVim's installation process by opening NeoVim and running :Lazy.

**Directory structure**
```tree
~/.config/nvim/
├── init.lua          # Main configuration file
├── lua/
│   ├── config/      # Configuration for various aspects
│   │   ├── keymaps.lua  # Custom keybindings
│   │   └── options.lua  # General NeoVim options
│   └── plugins/      # Plugin configuration files
│       ├── bufferline.lua  # Bufferline.nvim plugin configuration
│       ├── colorscheme.lua  # Colorscheme configuration
│       ├── completions.lua  # Completion plugins configuration
│       ├── dashboard.lua   # Dashboard plugin configuration (optional)
│       ├── debugging.lua    # Debugging plugin configuration (optional)
│       ├── edgy-nvim.lua    # Edgy.nvim plugin configuration
│       ├── lsp-config.lua   # LSP server configuration
│       ├── lualine.lua      # Lualine.nvim plugin configuration
│       ├── neo-tree.lua     # Neo-tree.nvim plugin configuration
│       ├── noice.lua        # Noice plugin configuration
│       ├── none-ls.lua      # None-ls plugin configuration (optional)
│       ├── telescope.lua    # Telescope.nvim plugin configuration
│       └── treesitter.lua   # Treesitter plugin configuration
│
└── waanney           # Your custom plugins or configurations (optional)
```
