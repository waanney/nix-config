{
  home.file.".config/nvim/lua/plugins/latex.lua".text = ''
    return {
      {
        "lervag/vimtex",
        ft = { "tex", "plaintex", "latex", "bib" },
        init = function()
          -- Cấu hình Zathura tích hợp chuẩn của VimTeX (tự quản lý 1 cửa sổ duy nhất)
          vim.g.vimtex_view_method = "zathura"
          vim.g.vimtex_compiler_method = "latexmk"
          vim.g.vimtex_quickfix_mode = 0
          vim.g.vimtex_complete_enabled = 0 -- Tắt complete cũ của VimTeX để Blink.cmp + TexLab xử lý siêu mượt


          vim.g.vimtex_compiler_latexmk = {
            continuous = 1,
            executable = "latexmk",
            options = {
              "-pdf",
              "-interaction=nonstopmode",
              "-synctex=1",
              "-file-line-error",
            },
          }
        end,
        config = function()
          -- Keybindings chuẩn chỉ của VimTeX
          vim.api.nvim_create_autocmd("FileType", {
            pattern = { "tex", "plaintex", "latex" },
            callback = function()
              vim.keymap.set("n", "<leader>ll", "<cmd>VimtexCompile<cr>", { buffer = true, desc = "Toggle Continuous Compile" })
              vim.keymap.set("n", "<leader>lv", "<cmd>VimtexView<cr>", { buffer = true, desc = "View PDF / Forward Search" })
              vim.keymap.set("n", "<leader>lk", "<cmd>VimtexStop<cr>", { buffer = true, desc = "Stop Compilation" })
              vim.keymap.set("n", "<leader>lc", "<cmd>VimtexClean<cr>", { buffer = true, desc = "Clean Aux Files" })
              vim.keymap.set("n", "<leader>lt", "<cmd>VimtexToggleMain<cr>", { buffer = true, desc = "Toggle Main File" })
            end,
          })
        end,
      },
    }
  '';
}
