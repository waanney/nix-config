{
  home.file.".config/nvim/lua/plugins/flash.lua".text =''
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    -- Customize the characters used for labels
    labels = "asdfghjklqwertyuiopzxcvbnm",
    
    -- Search settings
    search = {
      multi_window = true,
      forward = true,
      wrap = true,
      mode = "exact",  -- exact, search, fuzzy
      incremental = false,
    },
    
    -- Jump settings
    jump = {
      jumplist = true,
      pos = "start",  -- start, end, range
      history = false,
      register = false,
      nohlsearch = false,
      autojump = false,
    },
    
    -- Label settings
    label = {
      uppercase = true,
      exclude = "",
      current = true,
      after = true,
      before = false,
      style = "overlay",  -- eol, overlay, inline
      reuse = "lowercase",
      distance = true,
    },
    
    -- Highlight settings
    highlight = {
      backdrop = true,
      matches = true,
      priority = 5000,
      groups = {
        match = "FlashMatch",
        current = "FlashCurrent",
        backdrop = "FlashBackdrop",
        label = "FlashLabel",
      },
    },
    
    -- Modes
    modes = {
      -- char mode (f, F, t, T)
      char = {
        enabled = true,
        jump_labels = false,
        multi_line = true,
        label = { exclude = "hjkliardc" },
        keys = { "f", "F", "t", "T", ";", "," },
        char_actions = function(motion)
          return {
            [";"] = "next",
            [","] = "prev",
            [motion:lower()] = "next",
            [motion:upper()] = "prev",
          }
        end,
        search = { wrap = false },
        highlight = { backdrop = true },
      },
      
      -- search mode
      search = {
        enabled = true,
        highlight = { backdrop = false },
        jump = { history = true, register = true, nohlsearch = true },
        search = {
          mode = "search",
          incremental = true,
        },
      },
      
      -- treesitter
      treesitter = {
        labels = "abcdefghijklmnopqrstuvwxyz",
        jump = { pos = "range" },
        search = { incremental = false },
        label = { before = true, after = true, style = "inline" },
        highlight = {
          backdrop = false,
          matches = false,
        },
      },
    },
  },
  
  keys = {
    -- Main flash jump
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    
    -- Treesitter flash
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    
    -- Remote flash (jump to other windows)
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    
    -- Treesitter search
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    
    -- Toggle flash search (disable default search behavior)
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
}
  '';
}
