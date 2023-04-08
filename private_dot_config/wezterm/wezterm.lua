local wezterm = require("wezterm")

-- TODO: Add SSH? (wezterm.default_ssh_domains)
-- TODO: Reorder launch menu?
-- TODO: Shorten path in tab name?
-- TODO: Visual bell

local config = {
    color_scheme = "Ayu Mirage",
    font = wezterm.font_with_fallback {
        "JetBrains Mono",
        "Noto Color Emoji",
        { family = "Symbols Nerd Font Mono", scale = 0.85 },
    },
    font_size = 9.5,
    initial_rows = 30,
    initial_cols = 120,

    enable_scroll_bar = true,
    scrollback_lines = 100000,

    launch_menu = {},
}

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    -- TODO: Git Bash
    -- TODO: Remove docker WSLs from launch menu (wezterm.default_wsl_domains)
    -- Make the WSL domain the default
    config.default_domain = "WSL:Ubuntu"
    -- Change the local domain to use powershell
    config.default_prog = { "powershell.exe", "-NoLogo" }

    -- Find installed Visual Studio version(s) and add their powershell environments
    for _, vsvers in ipairs(wezterm.glob("Microsoft Visual Studio/20*", "C:/Program Files")) do
        local year = vsvers:gsub("Microsoft Visual Studio/", "")
        local vs_path = "C:/Program Files/" .. vsvers .. "/Community/"

        table.insert(config.launch_menu, {
            label = "Developer PowerShell for VS " .. year,
            args = {
                "powershell.exe",
                "-NoExit",
                "-Command",
                "&{Import-Module '"
                    .. vs_path
                    .. "Common7/Tools/Microsoft.VisualStudio.DevShell.dll'; Enter-VsDevShell -VsInstallPath '"
                    .. vs_path
                    .. "' -SkipAutomaticLocation}",
            },
            domain = { DomainName = "local" },
        })
    end
end

return config
