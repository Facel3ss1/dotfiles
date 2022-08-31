require("gitsigns").setup {
    on_attach = function(bufnr)
        local function hl(group, opts)
            vim.api.nvim_set_hl(0, group, opts)
        end

        local function fg_bg(fg_group, bg_group)
            local fg_hl = vim.api.nvim_get_hl_by_name(fg_group, true)
            local bg_hl = vim.api.nvim_get_hl_by_name(bg_group, true)
            return {
                fg = fg_hl.foreground,
                bg = bg_hl.background,
            }
        end

        -- Fix gitsigns background
        hl("GitSignsAdd", fg_bg("GitSignsAdd", "SignColumn"))
        hl("GitSignsChange", fg_bg("GitSignsChange", "SignColumn"))
        hl("GitSignsDelete", fg_bg("GitSignsDelete", "SignColumn"))
    end
}
