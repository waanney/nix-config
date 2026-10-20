_: {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require "wezterm"
      local act = wezterm.action

      local config = {}
      if wezterm.config_builder then
        config = wezterm.config_builder()
      end

      -- Rendering: smooth without wasting resources on UI animations.
      config.front_end = "OpenGL"
      config.webgpu_power_preference = "HighPerformance"
      config.max_fps = 120
      config.animation_fps = 60

      -- Font
      local font_name = "JetBrainsMono Nerd Font"
      local function font_with_fallback(params)
        return wezterm.font_with_fallback({
          { family = font_name, weight = params and params.weight or "Regular", italic = params and params.italic or false },
          "Material Symbols Outlined",
        })
      end

      config.font = font_with_fallback()
      config.font_size = 11
      config.line_height = 1.08
      config.font_rules = {
        {
          intensity = "Bold",
          italic = false,
          font = font_with_fallback({ weight = "Bold" }),
        },
        {
          intensity = "Normal",
          italic = true,
          font = font_with_fallback({ italic = true }),
        },
        {
          intensity = "Bold",
          italic = true,
          font = font_with_fallback({ weight = "Bold", italic = true }),
        },
      }

      -- Gruvbox Material, with enough contrast for long terminal sessions.
      local colors = {
        background = "#131313",
        surface = "#1d2021",
        surface_alt = "#282828",
        foreground = "#d4be98",
        muted = "#a89984",
        green = "#89b482",
        purple = "#d3869b",
      }

      config.color_scheme = "Gruvbox Material (Gogh)"
      config.colors = {
        background = colors.background,
        tab_bar = {
          background = colors.surface,
          inactive_tab_edge = colors.surface_alt,
        },
      }
      config.window_background_opacity = 0.96

      -- Window
      config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
      config.integrated_title_button_style = "Gnome"
      config.window_frame = {
        active_titlebar_bg = colors.surface,
        inactive_titlebar_bg = colors.surface,
        border_left_width = "0.15cell",
        border_right_width = "0.15cell",
        border_bottom_height = "0.1cell",
        border_top_height = "0cell",
        border_left_color = colors.green,
        border_right_color = colors.green,
        border_bottom_color = colors.green,
      }
      config.window_padding = {
        left = 10,
        right = 10,
        top = 8,
        bottom = 6,
      }

      -- General behavior
      config.enable_wayland = true
      config.enable_scroll_bar = false
      config.scrollback_lines = 20000
      config.warn_about_missing_glyphs = false
      config.check_for_updates = false
      config.automatically_reload_config = true
      config.adjust_window_size_when_changing_font_size = false
      config.default_cursor_style = "SteadyBar"
      config.cursor_blink_rate = 0
      config.window_close_confirmation = "AlwaysPrompt"
      config.exit_behavior = "CloseOnCleanExit"
      config.audible_bell = "Disabled"

      -- Tabs are shown from 1 so both the label and Alt+number feel natural.
      config.hide_tab_bar_if_only_one_tab = false
      config.tab_bar_at_bottom = true
      config.use_fancy_tab_bar = false
      config.tab_and_split_indices_are_zero_based = false
      config.show_new_tab_button_in_tab_bar = true
      config.show_tab_index_in_tab_bar = false

      local function tab_title(tab)
        local title = tab.tab_title
        if not title or title == "" then
          title = tab.active_pane.title
        end
        return wezterm.truncate_right(title, 28)
      end

      wezterm.on("format-tab-title", function(tab)
        local background = colors.surface_alt
        local foreground = colors.muted
        local marker = "  "

        if tab.is_active then
          background = colors.purple
          foreground = colors.surface
          marker = "● "
        end

        return {
          { Background = { Color = background } },
          { Foreground = { Color = foreground } },
          { Attribute = { Intensity = tab.is_active and "Bold" or "Normal" } },
          { Text = " " .. marker .. (tab.tab_index + 1) .. ": " .. tab_title(tab) .. " " },
        }
      end)

      -- Alt+q is the leader. The status bar makes its active state visible.
      config.leader = { key = "q", mods = "ALT", timeout_milliseconds = 1500 }
      wezterm.on("update-status", function(window)
        if window:leader_is_active() then
          window:set_left_status(wezterm.format({
            { Background = { Color = colors.green } },
            { Foreground = { Color = colors.surface } },
            { Attribute = { Intensity = "Bold" } },
            { Text = "  LEADER  " },
          }))
        else
          window:set_left_status("")
        end

        window:set_right_status(wezterm.format({
          { Foreground = { Color = colors.muted } },
          { Text = "  " .. window:active_workspace() .. "  " .. wezterm.strftime("%H:%M") .. "  " },
        }))
      end)

      -- Keep WezTerm's familiar defaults and add discoverable shortcuts.
      config.disable_default_key_bindings = false
      config.keys = {
        -- Clipboard and font size
        { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("ClipboardAndPrimarySelection") },
        { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
        { key = "=", mods = "CTRL", action = act.IncreaseFontSize },
        { key = "+", mods = "CTRL|SHIFT", action = act.IncreaseFontSize },
        { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
        { key = "0", mods = "CTRL", action = act.ResetFontSize },

        -- Common terminal shortcuts
        { key = "t", mods = "CTRL|SHIFT", action = act.SpawnTab("CurrentPaneDomain") },
        { key = "n", mods = "CTRL|SHIFT", action = act.SpawnWindow },
        { key = "w", mods = "CTRL|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },
        { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
        { key = "Tab", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },
        { key = "f", mods = "CTRL|SHIFT", action = act.Search("CurrentSelectionOrEmptyString") },
        { key = "p", mods = "CTRL|SHIFT", action = act.ActivateCommandPalette },
        { key = "o", mods = "CTRL|SHIFT", action = act.QuickSelect },
        { key = "F11", mods = "NONE", action = act.ToggleFullScreen },

        -- Leader shortcuts: tabs and panes
        { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
        { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
        { key = "b", mods = "LEADER", action = act.ActivateTabRelative(-1) },
        { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
        { key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
        { key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
        { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
        { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
        { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
        { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
        { key = "LeftArrow", mods = "LEADER", action = act.AdjustPaneSize({ "Left", 5 }) },
        { key = "RightArrow", mods = "LEADER", action = act.AdjustPaneSize({ "Right", 5 }) },
        { key = "DownArrow", mods = "LEADER", action = act.AdjustPaneSize({ "Down", 5 }) },
        { key = "UpArrow", mods = "LEADER", action = act.AdjustPaneSize({ "Up", 5 }) },
        { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
        { key = "[", mods = "LEADER", action = act.ActivateCopyMode },
        { key = "p", mods = "LEADER", action = act.ActivateCommandPalette },
      }

      for i = 1, 9 do
        table.insert(config.keys, {
          key = tostring(i),
          mods = "ALT",
          action = act.ActivateTab(i - 1),
        })
        table.insert(config.keys, {
          key = tostring(i),
          mods = "LEADER",
          action = act.ActivateTab(i - 1),
        })
      end

      return config
    '';
  };
}
