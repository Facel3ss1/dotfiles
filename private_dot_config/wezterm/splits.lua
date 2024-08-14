local wezterm = require("wezterm")

local function is_nvim(pane)
    -- This is set/unset by the smart-splits.nvim plugin
    return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
    h = "Left",
    j = "Down",
    k = "Up",
    l = "Right",
}

local function move_to_split(key)
    return {
        key = key,
        mods = "CTRL",
        action = wezterm.action_callback(function(window, pane)
            if is_nvim(pane) then
                window:perform_action(wezterm.action.SendKey { key = key, mods = "CTRL" }, pane)
            else
                window:perform_action(wezterm.action.ActivatePaneDirection(direction_keys[key]), pane)
            end
        end),
    }
end

local function resize_split(key)
    return {
        key = key,
        mods = "ALT",
        action = wezterm.action_callback(function(window, pane)
            if is_nvim(pane) then
                window:perform_action(wezterm.action.SendKey { key = key, mods = "ALT" }, pane)
            else
                window:perform_action(wezterm.action.AdjustPaneSize { direction_keys[key], 3 }, pane)
            end
        end),
    }
end

return {
    keys = {
        move_to_split("h"),
        move_to_split("j"),
        move_to_split("k"),
        move_to_split("l"),

        resize_split("h"),
        resize_split("j"),
        resize_split("k"),
        resize_split("l"),
    },
}
