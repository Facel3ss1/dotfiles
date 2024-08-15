local wezterm = require("wezterm")

local splits = require("splits")

-- TODO: Visual bell

local config = wezterm.config_builder()

-- Appearance
local commit_mono_features = { "calt=1", "liga=1", "ss01=1", "ss02=1" }

config.color_scheme = "Catppuccin Macchiato"
config.font = wezterm.font_with_fallback {
    {
        family = "CommitMono Nerd Font",
        -- See the "Features" section in the docs for Commit Mono
        harfbuzz_features = commit_mono_features,
    },
    { family = "JetBrains Mono" },
    { family = "Noto Color Emoji" },
    { family = "Symbols Nerd Font Mono" },
}
config.font_size = 12

-- Window
config.window_close_confirmation = "NeverPrompt"
config.initial_rows = 30
config.initial_cols = 120
config.scrollback_lines = 100000
config.window_frame = {
    font = wezterm.font_with_fallback {
        {
            family = "CommitMono",
            harfbuzz_features = commit_mono_features,
        },
        { family = "JetBrains Mono" },
    },
}

-- Focus window on startup
wezterm.on("gui-startup", function(cmd)
    local _tab, _pane, window = wezterm.mux.spawn_window(cmd or {})

    wezterm.mux.set_active_workspace("default")
    window:gui_window():focus()
end)

-- Tab Bar
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_max_width = 32

-- TODO: wezterm.on format-tab-title? e.g. show zoom status? domain name?

wezterm.on("update-status", function(window)
    local color_scheme = window:effective_config().resolved_palette
    local tab_bar_colors = color_scheme.tab_bar
    local bg = tab_bar_colors.active_tab.bg_color
    local fg = tab_bar_colors.active_tab.fg_color

    -- TODO: Set left status if leader key is active?

    window:set_right_status(wezterm.format {
        { Background = { Color = bg } },
        { Foreground = { Color = fg } },
        { Text = " " .. wezterm.mux.get_active_workspace() .. " " },
    })
end)

-- Keybinds
config.leader = { key = " ", mods = "CTRL", timeout_milliseconds = 1000 } -- Ctrl-Space
config.keys = {
    {
        key = "v",
        mods = "LEADER",
        action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" },
    },
    {
        key = "s",
        mods = "LEADER",
        action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" },
    },
    {
        key = "z",
        mods = "LEADER",
        action = wezterm.action.TogglePaneZoomState,
    },

    -- In case we ever want to type Ctrl-Space
    {
        key = " ",
        mods = "LEADER|CTRL",
        action = wezterm.action.SendKey { key = " ", mods = "CTRL" },
    },

    {
        key = ",",
        mods = "CTRL",
        action = wezterm.action_callback(function(window, pane)
            -- We can't just use "~", since it doesn't work for PowerShell 😒
            local domain_home_dir = wezterm.home_dir

            -- If this isn't the local domain, use "~", as we cannot determine the domain's home directory ourselves
            if pane:get_domain_name() ~= "local" then
                domain_home_dir = "~"
            end

            window:perform_action(
                wezterm.action.SwitchToWorkspace {
                    name = "dotfiles",
                    spawn = {
                        cwd = domain_home_dir .. "/.local/share/chezmoi",
                    },
                },
                pane
            )
        end),
    },
}

for _, key in ipairs(splits.keys) do
    table.insert(config.keys, key)
end

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    -- Set the default shell for the local domain to be PowerShell
    local pwsh_exists = pcall(function()
        wezterm.run_child_process { "pwsh.exe", "--version" }
    end)

    if pwsh_exists then
        config.default_prog = { "pwsh.exe" }
    else
        config.default_prog = { "powershell.exe" }
    end

    -- Remove Docker's WSL from the list of WSL domains
    local default_wsl_domains = wezterm.default_wsl_domains()
    local wsl_domains = {}

    for _, wsl_domain in ipairs(default_wsl_domains) do
        if wsl_domain.distribution ~= "docker-desktop-data" then
            table.insert(wsl_domains, wsl_domain)
        end
    end

    config.wsl_domains = wsl_domains

    -- Make the WSL domain the default, if available
    if #wsl_domains > 0 then
        config.default_domain = wsl_domains[1].name
    end
end

return config
