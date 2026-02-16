_: {
  programs.wezterm = {
    enable = true;
    # package = inputs.self.packages.${pkgs.system}.wezterm;
    extraConfig = ''
      -- Pull in the wezterm API
      local wezterm = require "wezterm"

      -- This table will hold the configuration.
      local config = {}

      -- In newer versions of wezterm, use the config_builder which will
      -- help provide clearer error messages
      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      -- max fps
      config.max_fps = 240
      config.animation_fps = 240

      --[[
      ============================
      Custom Configuration
      ============================
      ]]

      -- Rounded or Square Style Tabs
      local tab_style = "square"

      -- leader active indicator prefix
      local leader_prefix = utf8.char(0x1f30a) -- ocean wave

      --[[
      ============================
      Font (Preserved from original config)
      ============================
      ]]

      local function font_with_fallback(name, params)
        local names = { name, "Material Symbols Outlined"}
        return wezterm.font_with_fallback(names, params)
      end

      local font_name = "Iosevka Nerd Font"

      config.font = font_with_fallback(font_name)
      config.font_size = 10
      config.font_rules = {
        {
          italic = true,
          font = font_with_fallback(font_name, { italic = true }),
        },
        {
          italic = false,
          font = font_with_fallback(font_name, { bold = true }),
        },
        {
          intensity = "Bold",
          font = font_with_fallback(font_name, { bold = true }),
        },
      }

      --[[
      ============================
      Colors (Preserved from original config)
      ============================
      ]]

      config.colors = {
        background = "#131313"
      }
      config.color_scheme = "Gruvbox Material (Gogh)"
      config.window_background_opacity = 0.90

      -- Get scheme colors for tab bar styling
      local scheme_colors = {
        gruvbox = {
          text = "#d4be98",
          crust = "#1d2021",
          lavender = "#89b482",
          mauve = "#d3869b",
        }
      }

      local colors = {
        border = scheme_colors.gruvbox.lavender,
        tab_bar_active_tab_fg = scheme_colors.gruvbox.mauve,
        tab_bar_active_tab_bg = scheme_colors.gruvbox.crust,
        tab_bar_text = scheme_colors.gruvbox.crust,
        arrow_foreground_leader = scheme_colors.gruvbox.lavender,
        arrow_background_leader = scheme_colors.gruvbox.crust,
      }

      --[[
      ============================
      Border
      ============================
      ]]

      config.window_frame = {
        border_left_width = "0.4cell",
        border_right_width = "0.4cell",
        border_bottom_height = "0.15cell",
        border_top_height = "0.15cell",
        border_left_color = colors.border,
        border_right_color = colors.border,
        border_bottom_color = colors.border,
        border_top_color = colors.border,
      }

      config.window_decorations = "NONE"

      --[[
      ============================
      General Settings (Preserved from original)
      ============================
      ]]

      config.warn_about_missing_glyphs = false
      config.enable_scroll_bar = false
      config.scrollback_lines = 10000
      config.window_padding = {
        left = 2,
        right = 2,
        top = 2,
        bottom = 1,
      }
      config.enable_wayland = true
      config.check_for_updates = false
      config.default_cursor_style = "SteadyBar"
      config.automatically_reload_config = true
      config.window_close_confirmation = "NeverPrompt"

      --[[
      ============================
      Shortcuts
      ============================
      ]]

      config.leader = { key = "q", mods = "ALT", timeout_milliseconds = 2000 }
      config.disable_default_key_bindings = true
      config.keys = {
        -- Original keybindings (preserved)
        {
          key = "v",
          mods = "CTRL|SHIFT",
          action = wezterm.action.PasteFrom("Clipboard"),
        },
        {
          key = "c",
          mods = "CTRL|SHIFT",
          action = wezterm.action.CopyTo("ClipboardAndPrimarySelection"),
        },
        -- New leader-based keybindings
        {
          mods = "LEADER",
          key = "c",
          action = wezterm.action.SpawnTab("CurrentPaneDomain"),
        },
        {
          mods = "LEADER",
          key = "x",
          action = wezterm.action.CloseCurrentPane({ confirm = true }),
        },
        {
          mods = "LEADER",
          key = "b",
          action = wezterm.action.ActivateTabRelative(-1),
        },
        {
          mods = "LEADER",
          key = "n",
          action = wezterm.action.ActivateTabRelative(1),
        },
        {
          mods = "LEADER",
          key = "=",
          action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
        },
        {
          mods = "LEADER",
          key = "-",
          action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
        },
        {
          mods = "LEADER",
          key = "h",
          action = wezterm.action.ActivatePaneDirection("Left"),
        },
        {
          mods = "LEADER",
          key = "j",
          action = wezterm.action.ActivatePaneDirection("Down"),
        },
        {
          mods = "LEADER",
          key = "k",
          action = wezterm.action.ActivatePaneDirection("Up"),
        },
        {
          mods = "LEADER",
          key = "l",
          action = wezterm.action.ActivatePaneDirection("Right"),
        },
        {
          mods = "LEADER",
          key = "LeftArrow",
          action = wezterm.action.AdjustPaneSize({ "Left", 5 }),
        },
        {
          mods = "LEADER",
          key = "RightArrow",
          action = wezterm.action.AdjustPaneSize({ "Right", 5 }),
        },
        {
          mods = "LEADER",
          key = "DownArrow",
          action = wezterm.action.AdjustPaneSize({ "Down", 5 }),
        },
        {
          mods = "LEADER",
          key = "UpArrow",
          action = wezterm.action.AdjustPaneSize({ "Up", 5 }),
        },
      }

      -- Add number keys for tab switching
      for i = 0, 9 do
        table.insert(config.keys, {
          key = tostring(i),
          mods = "LEADER",
          action = wezterm.action.ActivateTab(i),
        })
      end

      --[[
      ============================
      Tab Bar
      ============================
      ]]

      config.hide_tab_bar_if_only_one_tab = false
      config.tab_bar_at_bottom = true
      config.use_fancy_tab_bar = false
      config.tab_and_split_indices_are_zero_based = true

      local function tab_title(tab_info)
        local title = tab_info.tab_title
        -- if the tab title is explicitly set, take that
        if title and #title > 0 then
          return title
        end
        -- Otherwise, use the title from the active pane
        return tab_info.active_pane.title
      end

      wezterm.on(
        "format-tab-title",
        function(tab, tabs, panes, config, hover, max_width)
          local title = " " .. tab.tab_index .. ": " .. tab_title(tab) .. " "
          local left_edge_text = ""
          local right_edge_text = ""

          if tab_style == "rounded" then
            title = tab.tab_index .. ": " .. tab_title(tab)
            title = wezterm.truncate_right(title, max_width - 2)
            left_edge_text = wezterm.nerdfonts.ple_left_half_circle_thick
            right_edge_text = wezterm.nerdfonts.ple_right_half_circle_thick
          end

          if tab.is_active then
            return {
              { Background = { Color = colors.tab_bar_active_tab_bg } },
              { Foreground = { Color = colors.tab_bar_active_tab_fg } },
              { Text = left_edge_text },
              { Background = { Color = colors.tab_bar_active_tab_fg } },
              { Foreground = { Color = colors.tab_bar_text } },
              { Text = title },
              { Background = { Color = colors.tab_bar_active_tab_bg } },
              { Foreground = { Color = colors.tab_bar_active_tab_fg } },
              { Text = right_edge_text },
            }
          end
        end
      )

      --[[
      ============================
      Leader Active Indicator
      ============================
      ]]

      wezterm.on("update-status", function(window, _)
        -- leader inactive
        local solid_left_arrow = ""
        local arrow_foreground = { Foreground = { Color = colors.arrow_foreground_leader } }
        local arrow_background = { Background = { Color = colors.arrow_background_leader } }
        local prefix = ""

        -- leader is active
        if window:leader_is_active() then
          prefix = " " .. leader_prefix

          if tab_style == "rounded" then
            solid_left_arrow = wezterm.nerdfonts.ple_right_half_circle_thick
          else
            solid_left_arrow = wezterm.nerdfonts.pl_left_hard_divider
          end

          local tabs = window:mux_window():tabs_with_info()

          if tab_style ~= "rounded" then
            for _, tab_info in ipairs(tabs) do
              if tab_info.is_active and tab_info.index == 0 then
                arrow_background = { Foreground = { Color = colors.tab_bar_active_tab_fg } }
                solid_left_arrow = wezterm.nerdfonts.pl_right_hard_divider
                break
              end
            end
          end
        end

        window:set_left_status(wezterm.format({
          { Background = { Color = colors.arrow_foreground_leader } },
          { Text = prefix },
          arrow_foreground,
          arrow_background,
          { Text = solid_left_arrow }
        }))
      end)

      -- Return the configuration to wezterm
      return config
    '';
  };
}
