 return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy", -- Load only when needed
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = { -- Default options that can be overridden
    options = {
      numbers = "ordinal",
      close_command = "bdelete! %d",
      right_mouse_command = "bdelete! %d",
      left_mouse_command = "buffer %d",
      middle_mouse_command = nil,
      offsets = {
        {
          filetype = "NvimTree",
          text = "File Explorer",
          text_align = "center",
          separator = true,
        },
      },
      buffer_close_icon = "x",
      modified_icon = "●", -- Use a more common icon
      close_icon = "",   -- Use a better close icon
      left_trunc_marker = "❮",
      right_trunc_marker = "❯",
      max_name_length = 14,
      max_prefix_length = 13,
      tab_size = 18,
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(count, level)
        local icon = level == "error" and " " or " " -- Use more common icons
        return " " .. icon .. count
      end,
      color_icons = true,
      show_buffer_close_icons = true,
      show_close_icon = false,
      show_tab_indicators = true,
      persist_buffer_sort = true,
      enforce_regular_tabs = true,
      always_show_bufferline = true,
    },
  },
  config = function(_, opts) -- Receive opts here
    require("bufferline").setup(opts) -- Pass opts to setup

    -- Key mappings (moved inside config for consistency with LazyVim)
    local keymap = vim.keymap.set
    keymap("n", "<Tab>", ":BufferLineCycleNext<CR>", { desc = "Cycle to next buffer" })
    keymap("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { desc = "Cycle to previous buffer" })
    keymap("n", "<C-q>", "<cmd>bd<CR>", {})
  end,
}
