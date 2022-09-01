local M = {}

M.hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

M.fg_bg = function(fg_group, bg_group)
    local fg_hl = vim.api.nvim_get_hl_by_name(fg_group, true)
    local bg_hl = vim.api.nvim_get_hl_by_name(bg_group, true)
    return {
        fg = fg_hl.foreground,
        bg = bg_hl.background,
    }
end

return M
