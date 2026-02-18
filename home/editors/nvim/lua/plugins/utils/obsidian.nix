{
  home.file.".config/nvim/lua/plugins/obsidian.lua".text = ''
    return {
      "epwalsh/obsidian.nvim",
      version = "*",
      lazy = true,
      -- Chỉ load khi mở file markdown trong vault
      event = {
        "BufReadPre " .. vim.fn.expand("~") .. "/Documents/01_Vault/**.md",
        "BufNewFile " .. vim.fn.expand("~") .. "/Documents/01_Vault/**.md",
      },
      dependencies = {
        "nvim-lua/plenary.nvim",
        "hrsh7th/nvim-cmp",
        "nvim-telescope/telescope.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
      opts = {
        workspaces = {
          {
            name = "personal",
            path = "~/Documents/01_Vault",
          },
        },

        -- Tắt UI của obsidian.nvim vì đang dùng render-markdown.nvim
        -- Hai plugin này xung đột nếu cùng bật UI
        ui = { enable = false },

        -- Completion
        completion = {
          nvim_cmp = true,
          min_chars = 2,
        },

        -- Templates
        templates = {
          folder = "06_Templates",
          date_format = "%Y-%m-%d",
          time_format = "%H:%M",
          substitutions = {},
        },

        -- Note ID theo Zettelkasten
        note_id_func = function(title)
          local suffix = ""
          if title ~= nil then
            suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
          else
            for _ = 1, 4 do
              suffix = suffix .. string.char(math.random(65, 90))
            end
          end
          return tostring(os.time()) .. "-" .. suffix
        end,

        -- Frontmatter
        note_frontmatter_func = function(note)
          if note.title then
            note:add_alias(note.title)
          end
          local out = { id = note.id, aliases = note.aliases, tags = note.tags }
          if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
            for k, v in pairs(note.metadata) do
              out[k] = v
            end
          end
          return out
        end,

        -- Vị trí note mới
        new_notes_location = "notes_subdir",

        -- Link style
        preferred_link_style = "wiki",

        -- Mở URL bằng xdg-open (Linux)
        follow_url_func = function(url)
          vim.fn.jobstart({ "xdg-open", url })
        end,

        -- Keymaps
        mappings = {
          ["gf"] = {
            action = function()
              return require("obsidian").util.gf_passthrough()
            end,
            opts = { noremap = false, expr = true, buffer = true },
          },
          ["<leader>ch"] = {
            action = function()
              return require("obsidian").util.toggle_checkbox()
            end,
            opts = { buffer = true },
          },
          ["<cr>"] = {
            action = function()
              return require("obsidian").util.smart_action()
            end,
            opts = { buffer = true, expr = true },
          },
        },

        -- Attachments
        attachments = {
          img_folder = "assets/imgs",
        },
      },
    }
  '';
}
