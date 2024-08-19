local wezterm = require("wezterm")

local M = {}

local function tab_bar_color_scheme(effective_config)
    local color_scheme = effective_config.resolved_palette
    local tab_bar = color_scheme.tab_bar

    return {
        bg_a = tab_bar.active_tab.bg_color,
        fg_a = tab_bar.active_tab.fg_color,
        bg_b = tab_bar.new_tab.bg_color,
        fg_b = tab_bar.new_tab.fg_color,
        bg_c = tab_bar.background,
        fg_c = color_scheme.foreground,
    }
end

function M.update_status(window, pane)
    local _pane = pane

    local tab_bar_colors = tab_bar_color_scheme(window:effective_config())

    local workspace_or_leader = wezterm.mux.get_active_workspace()
    if window:leader_is_active() then
        workspace_or_leader = "LEADER"
    end

    window:set_right_status(wezterm.format {
        { Background = { Color = tab_bar_colors.bg_a } },
        { Foreground = { Color = tab_bar_colors.fg_a } },
        { Text = " " .. workspace_or_leader .. " " },
    })
end

return M
