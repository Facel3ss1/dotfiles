local remap = require("peter.remap")

-- TODO: hunk text objects

require("gitsigns").setup {
    preview_config = {
        border = "rounded",
    },
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local nnoremap = remap.bind("n", { buffer = bufnr })
        local xnoremap = remap.bind("x", { buffer = bufnr })

        nnoremap("]c", function()
            if vim.wo.diff then
                return "]c"
            end
            vim.schedule(function()
                gs.next_hunk()
            end)
            return "<Ignore>"
        end, { expr = true, desc = "Next change" })

        nnoremap("[c", function()
            if vim.wo.diff then
                return "[c"
            end
            vim.schedule(function()
                gs.prev_hunk()
            end)
            return "<Ignore>"
        end, { expr = true, desc = "Previous change" })

        nnoremap("<leader>ga", ":Gitsigns stage_hunk<CR>", { desc = "Stage change" })
        xnoremap("<leader>ga", ":Gitsigns stage_hunk<CR>", { desc = "Stage change (visual)" })
        nnoremap("<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Reset change" })
        xnoremap("<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Reset change (visual)" })

        nnoremap("<leader>gA", gs.stage_buffer, { desc = "Stage buffer" })
        nnoremap("<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
        nnoremap("<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage change" })
        nnoremap("<leader>gp", gs.preview_hunk, { desc = "Preview change" })
    end,
}
