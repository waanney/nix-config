{
  home.file.".config/nvim/lua/plugins/markdown.lua".text = ''
    return {
      {
        -- ─── render-markdown.nvim ────────────────────────────────────────────
        -- Render markdown đẹp trong buffer (thay thế UI của obsidian.nvim)
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
          "echasnovski/mini.icons",
        },
        ft = { "markdown", "Avante" },
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {
          -- Bật cho cả file markdown thường và obsidian vault
          file_types = { "markdown", "Avante" },

          -- Render headings với màu sắc đẹp
          heading = {
            enabled = true,
            sign = true,
            -- Ký tự thay thế cho heading
            icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
            -- Background màu cho từng level heading
            backgrounds = {
              "RenderMarkdownH1Bg",
              "RenderMarkdownH2Bg",
              "RenderMarkdownH3Bg",
              "RenderMarkdownH4Bg",
              "RenderMarkdownH5Bg",
              "RenderMarkdownH6Bg",
            },
            foregrounds = {
              "RenderMarkdownH1",
              "RenderMarkdownH2",
              "RenderMarkdownH3",
              "RenderMarkdownH4",
              "RenderMarkdownH5",
              "RenderMarkdownH6",
            },
          },

          -- Render code blocks
          code = {
            enabled = true,
            sign = true,
            style = "language",       -- "full" | "normal" | "language" | "none"
            position = "left",
            language_pad = 1,
            width = "full",
            left_pad = 2,
            right_pad = 2,
            min_width = 40,
            border = "thick",      -- "thin" | "thick" | "none"
            above = "▄",
            below = "▀",
            highlight = "RenderMarkdownCode",
            highlight_inline = "RenderMarkdownCodeInline",
          },

          -- Render bullet points đẹp hơn
          bullet = {
            enabled = true,
            icons = { "●", "○", "◆", "◇" },
            left_pad = 0,
            right_pad = 1,
            highlight = "RenderMarkdownBullet",
          },

          -- Render checkboxes (phối hợp với obsidian.nvim toggle)
          checkbox = {
            enabled = true,
            unchecked = {
              icon = "󰄱 ",
              highlight = "RenderMarkdownUnchecked",
            },
            checked = {
              icon = "󰱒 ",
              highlight = "RenderMarkdownChecked",
            },
            custom = {
              -- Obsidian custom states
              todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
              important = { raw = "[!]", rendered = "󰀦 ", highlight = "RenderMarkdownWarn" },
            },
          },

          -- Render quote blocks
          quote = {
            enabled = true,
            icon = "▋",
            repeat_linebreak = false,
            highlight = "RenderMarkdownQuote",
          },

          -- Render tables
          pipe_table = {
            enabled = true,
            preset = "double",    -- "none" | "round" | "double" | "heavy"
            style = "full",
            cell = "padded",
            alignment_indicator = "━",
            head = "RenderMarkdownTableHead",
            row = "RenderMarkdownTableRow",
            filler = "RenderMarkdownTableFill",
          },

          -- Render callouts (Obsidian-style > [!NOTE] etc.)
          callout = {
            note      = { raw = "[!NOTE]",      rendered = "󰋽 Note",      highlight = "RenderMarkdownInfo" },
            tip       = { raw = "[!TIP]",       rendered = "󰌶 Tip",       highlight = "RenderMarkdownSuccess" },
            important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
            warning   = { raw = "[!WARNING]",   rendered = "󰀪 Warning",   highlight = "RenderMarkdownWarn" },
            caution   = { raw = "[!CAUTION]",   rendered = "󰳦 Caution",   highlight = "RenderMarkdownError" },
            -- Obsidian-specific callouts
            abstract  = { raw = "[!ABSTRACT]",  rendered = "󰨸 Abstract",  highlight = "RenderMarkdownInfo" },
            summary   = { raw = "[!SUMMARY]",   rendered = "󰨸 Summary",   highlight = "RenderMarkdownInfo" },
            tldr      = { raw = "[!TLDR]",      rendered = "󰨸 TL;DR",     highlight = "RenderMarkdownInfo" },
            info      = { raw = "[!INFO]",      rendered = "󰋽 Info",      highlight = "RenderMarkdownInfo" },
            todo      = { raw = "[!TODO]",      rendered = "󰗡 Todo",      highlight = "RenderMarkdownInfo" },
            hint      = { raw = "[!HINT]",      rendered = "󰌶 Hint",      highlight = "RenderMarkdownSuccess" },
            success   = { raw = "[!SUCCESS]",   rendered = "󰄬 Success",   highlight = "RenderMarkdownSuccess" },
            check     = { raw = "[!CHECK]",     rendered = "󰄬 Check",     highlight = "RenderMarkdownSuccess" },
            done      = { raw = "[!DONE]",      rendered = "󰄬 Done",      highlight = "RenderMarkdownSuccess" },
            question  = { raw = "[!QUESTION]",  rendered = "󰘥 Question",  highlight = "RenderMarkdownWarn" },
            help      = { raw = "[!HELP]",      rendered = "󰘥 Help",      highlight = "RenderMarkdownWarn" },
            faq       = { raw = "[!FAQ]",       rendered = "󰘥 FAQ",       highlight = "RenderMarkdownWarn" },
            attention = { raw = "[!ATTENTION]", rendered = "󰀪 Attention", highlight = "RenderMarkdownWarn" },
            failure   = { raw = "[!FAILURE]",   rendered = "󰅖 Failure",   highlight = "RenderMarkdownError" },
            fail      = { raw = "[!FAIL]",      rendered = "󰅖 Fail",      highlight = "RenderMarkdownError" },
            missing   = { raw = "[!MISSING]",   rendered = "󰅖 Missing",   highlight = "RenderMarkdownError" },
            danger    = { raw = "[!DANGER]",    rendered = "󱐌 Danger",    highlight = "RenderMarkdownError" },
            error     = { raw = "[!ERROR]",     rendered = "󰅖 Error",     highlight = "RenderMarkdownError" },
            bug       = { raw = "[!BUG]",       rendered = "󰨰 Bug",       highlight = "RenderMarkdownError" },
            example   = { raw = "[!EXAMPLE]",   rendered = "󰉹 Example",   highlight = "RenderMarkdownHint" },
            quote     = { raw = "[!QUOTE]",     rendered = "󱆨 Quote",     highlight = "RenderMarkdownQuote" },
            cite      = { raw = "[!CITE]",      rendered = "󱆨 Cite",      highlight = "RenderMarkdownQuote" },
          },

          -- Render links
          link = {
            enabled = true,
            footnote = {
              superscript = true,
              prefix = "",
              suffix = "",
            },
            image = "󰥶 ",
            email = "󰀓 ",
            hyperlink = "󰌹 ",
            highlight = "RenderMarkdownLink",
            wiki = {
              icon = "󱗖 ",
              highlight = "RenderMarkdownWikiLink",
            },
            custom = {
              -- Obsidian internal links
              obsidian = { pattern = "^obsidian://", icon = "󰠮 ", highlight = "RenderMarkdownLink" },
            },
          },

          -- Render dấu phân cách (---)
          dash = {
            enabled = true,
            icon = "─",
            width = "full",
            highlight = "RenderMarkdownDash",
          },

          -- Inline code
          inline_highlight = {
            enabled = true,
            highlight = "RenderMarkdownCodeInline",
          },

          -- Conceal level cần thiết để render
          -- Tự set conceallevel khi vào markdown buffer
          on = {
            attach = function()
              vim.opt_local.conceallevel = 2
              vim.opt_local.concealcursor = "nc"
            end,
          },
        },
      },

      {
        -- ─── markdown-preview.nvim ───────────────────────────────────────────
        -- Preview markdown trong browser (hữu ích cho file ngoài vault)
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
          vim.fn["mkdp#util#install"]()
        end,
        keys = {
          { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", ft = "markdown", desc = "Markdown Preview" },
        },
      },
    }
  '';
}
