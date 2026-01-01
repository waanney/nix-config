{
  home.file.".config/nvim/lua/plugins/latex.lua".text = ''
return {
  {
    "lervag/vimtex",
    ft = { "tex", "plaintex", "latex" },
    init = function()
      -- Use zathura as PDF viewer
      vim.g.vimtex_view_method = "zathura"
      
      -- Ensure zathura is found - try to find it in PATH
      local zathura_path = vim.fn.exepath("zathura")
      if zathura_path == "" then
        -- If not found, try common Nix store paths
        local paths = vim.fn.glob("/nix/store/*/bin/zathura", false, true)
        if paths and #paths > 0 then
          zathura_path = paths[1]
        end
      end
      if zathura_path ~= "" then
        vim.g.vimtex_view_zathura_exe = zathura_path
      end
      
      -- Ensure zathura can run in background (non-blocking)
      vim.g.vimtex_view_zathura_sendkeys = ""
      
      -- Disable quickfix window (use LSP diagnostics instead)
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_quickfix_ignore_filters = {
        "Overfull",
        "Underfull",
        "Package hyperref Warning",
      }
      -- Don't open quickfix automatically
      vim.g.vimtex_quickfix_open_on_warning = 0
      -- Don't show compiler messages in command line
      vim.g.vimtex_compiler_latexmk_engines = {
        _ = "-pdf",
      }
      -- Suppress compiler output messages
      vim.g.vimtex_echo_verbose_input = 0
      
      -- Continuous compilation with latexmk (only compile on save, not on view)
      vim.g.vimtex_compiler_latexmk = {
        continuous = 1,
        executable = "latexmk",
        callback = 1,
        build_dir = "",  -- Build in same directory as source
        options = {
          "-pdf",
          "-interaction=nonstopmode",
          "-synctex=1",
          "-file-line-error",
        },
      }
      
      -- Only compile on save, disable auto-compile on other events
      vim.g.vimtex_compiler_latexmk_continuous = 1
      vim.g.vimtex_compiler_latexmk_callback_hooks = {}
      
      -- Enable forward/inverse search with zathura
      vim.g.vimtex_view_zathura_options = "--synctex-forward @line:@col:@tex @pdf"
      
      -- Configure inverse search (Ctrl+Click in PDF → jump to Neovim)
      -- Get Neovim server name for synctex
      local nvim_server = vim.v.servername or ""
      if nvim_server ~= "" then
        -- Configure zathura to call Neovim for inverse search using nvr
        vim.g.vimtex_view_zathura_synctex = {
          cmd = "nvr",
          args = {
            "--servername", nvim_server,
            "--remote-silent",
            "+%{line}",
            "%{input}"
          }
        }
      else
        -- Fallback: try to find any running Neovim instance
        vim.g.vimtex_view_zathura_synctex = {
          cmd = "nvr",
          args = {
            "--remote-silent",
            "+%{line}",
            "%{input}"
          }
        }
      end
      
      -- Configure inverse search (Ctrl+Click in PDF → jump to Neovim)
      -- Get Neovim server name for synctex
      local nvim_server = vim.v.servername or ""
      if nvim_server ~= "" then
        -- Configure zathura to call Neovim for inverse search
        vim.g.vimtex_view_zathura_synctex = {
          cmd = "nvr",
          args = {
            "--servername", nvim_server,
            "--remote-silent",
            "+%{line}",
            "%{input}"
          }
        }
      else
        -- Fallback: use nvim-remote if available, or just nvim
        vim.g.vimtex_view_zathura_synctex = {
          cmd = "nvr",
          args = {
            "--remote-silent",
            "+%{line}",
            "%{input}"
          }
        }
      end
      
      -- Auto-compile on save
      vim.g.vimtex_compiler_latexmk_engines = {
        _ = "-pdf",
      }
      
      -- Auto-open PDF viewer when compilation succeeds (but wait for PDF to be created)
      vim.g.vimtex_view_automatic = 0  -- We'll handle opening manually after PDF is ready
      
      -- Ensure continuous mode is enabled
      vim.g.vimtex_compiler_latexmk_continuous = 1
    end,
    config = function()
      -- Key mappings for vimtex
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "tex", "plaintex", "latex" },
        callback = function()
          -- Auto-start compilation when opening LaTeX file
          vim.cmd("VimtexCompile")
          
          -- Compile document
          vim.keymap.set("n", "<leader>ll", "<cmd>VimtexCompile<cr>", { buffer = true, desc = "Compile LaTeX" })
          -- Stop compilation
          vim.keymap.set("n", "<leader>lk", "<cmd>VimtexStop<cr>", { buffer = true, desc = "Stop compilation" })
          -- Clean auxiliary files
          vim.keymap.set("n", "<leader>lc", "<cmd>VimtexClean<cr>", { buffer = true, desc = "Clean aux files" })
          -- View PDF - only open if zathura is not already running
          vim.keymap.set("n", "<leader>lv", function()
            local pdf_file = vim.fn.expand("%:r") .. ".pdf"
            if vim.fn.filereadable(pdf_file) == 1 then
              -- Check if zathura is already running
              local zathura_running = vim.fn.system("pgrep -x zathura > /dev/null 2>&1 && echo 'yes' || echo 'no'")
              if zathura_running:match("no") then
                -- Zathura is not running, open it
                local zathura_cmd = vim.fn.exepath("zathura") or "zathura"
                local nvim_server = vim.v.servername or ""
                -- Open zathura with synctex support for inverse search
                if nvim_server ~= "" then
                  vim.fn.jobstart({zathura_cmd, "--synctex-editor-command", "nvr --servername " .. nvim_server .. " --remote-silent +%{line} %{input}", pdf_file}, {detach = true})
                else
                  vim.fn.jobstart({zathura_cmd, pdf_file}, {detach = true})
                end
              else
                -- Zathura is already running, just refresh the PDF view
                -- Send 'r' key to zathura to reload (if using zathura's IPC)
                -- Or just do nothing - zathura should auto-refresh on file change
                vim.notify("Zathura is already running", vim.log.levels.INFO)
              end
            else
              vim.notify("PDF file not found: " .. pdf_file, vim.log.levels.WARN)
            end
          end, { buffer = true, desc = "View PDF" })
          -- Toggle compiler
          vim.keymap.set("n", "<leader>lt", "<cmd>VimtexToggleMain<cr>", { buffer = true, desc = "Toggle main file" })
        end,
      })
      
      -- Hook into compilation success to ensure viewer opens AFTER PDF is created
      vim.api.nvim_create_autocmd("User", {
        pattern = "VimtexEventCompileSuccess",
        callback = function()
          -- Wait a bit for PDF to be fully written, then check and open viewer
          vim.defer_fn(function()
            local tex_file = vim.fn.expand("%:r")
            local pdf_file = tex_file .. ".pdf"
            -- Check if PDF file exists before opening viewer
            if vim.fn.filereadable(pdf_file) == 1 then
              -- Check if zathura is already running
              local zathura_running = vim.fn.system("pgrep -x zathura > /dev/null 2>&1 && echo 'yes' || echo 'no'")
              if zathura_running:match("no") then
                -- Zathura is not running, open it directly (skip vimtex to avoid multiple instances)
                local zathura_cmd = vim.fn.exepath("zathura") or "zathura"
                local nvim_server = vim.v.servername or ""
                -- Open zathura with synctex support for inverse search
                if nvim_server ~= "" then
                  vim.fn.jobstart({zathura_cmd, "--synctex-editor-command", "nvr --servername " .. nvim_server .. " --remote-silent +%{line} %{input}", pdf_file}, {detach = true})
                else
                  vim.fn.jobstart({zathura_cmd, pdf_file}, {detach = true})
                end
              end
              -- If zathura is already running, don't open a new instance
            else
              -- If PDF doesn't exist yet, wait a bit more and try again
              vim.defer_fn(function()
                if vim.fn.filereadable(pdf_file) == 1 then
                  -- Check if zathura is already running
                  local zathura_running = vim.fn.system("pgrep -x zathura > /dev/null 2>&1 && echo 'yes' || echo 'no'")
                  if zathura_running:match("no") then
                    -- Zathura is not running, open it directly
                    local zathura_cmd = vim.fn.exepath("zathura") or "zathura"
                    local nvim_server = vim.v.servername or ""
                    -- Open zathura with synctex support for inverse search
                    if nvim_server ~= "" then
                      vim.fn.jobstart({zathura_cmd, "--synctex-editor-command", "nvr --servername " .. nvim_server .. " --remote-silent +%{line} %{input}", pdf_file}, {detach = true})
                    else
                      vim.fn.jobstart({zathura_cmd, pdf_file}, {detach = true})
                    end
                  end
                end
              end, 500)
            end
          end, 300)  -- Initial delay of 300ms
        end,
      })
    end,
  },
}
  '';
}

