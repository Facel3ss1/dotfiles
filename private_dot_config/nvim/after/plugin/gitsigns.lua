local keymap = require("peter.keymap")

require("gitsigns").setup {
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local nnoremap = keymap.bind("n", {buffer = bufnr})
        local vnoremap = keymap.bind("v", {buffer = bufnr})

        nnoremap("]c", function()
            if vim.wo.diff then return "]c" end
            vim.schedule(function() gs.next_hunk() end)
            return "<Ignore>"
        end, {expr = true})

        nnoremap("[c", function()
            if vim.wo.diff then return "[c" end
            vim.schedule(function() gs.prev_hunk() end)
            return "<Ignore>"
        end, {expr = true})

        nnoremap("<leader>hs", ":Gitsigns stage_hunk<CR>")
        vnoremap("<leader>hs", ":Gitsigns stage_hunk<CR>")
        nnoremap("<leader>hr", ":Gitsigns reset_hunk<CR>")
        vnoremap("<leader>hr", ":Gitsigns reset_hunk<CR>")

        nnoremap("<leader>hS", gs.stage_buffer)
        nnoremap("<leader>hu", gs.undo_stage_hunk)
        nnoremap("<leader>hR", gs.reset_buffer)
        nnoremap("<leader>hp", gs.preview_hunk)

        -- Fix gitsigns background
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

        hl("GitSignsAdd", fg_bg("GitSignsAdd", "SignColumn"))
        hl("GitSignsChange", fg_bg("GitSignsChange", "SignColumn"))
        hl("GitSignsDelete", fg_bg("GitSignsDelete", "SignColumn"))
    end
}
