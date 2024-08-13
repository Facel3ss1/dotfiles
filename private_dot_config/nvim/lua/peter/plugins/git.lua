local icons = require("peter.util.icons")

-- TODO: diffconflicts?

---@module "lazy"
---@type LazySpec
return {
    -- TODO: Use mini.diff?
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        opts = {
            preview_config = {
                border = "rounded",
            },
            on_attach = function(bufnr)
                -- TODO: hunk text objects

                local gs = package.loaded.gitsigns

                local function map(mode, lhs, rhs, opts)
                    opts.buffer = bufnr
                    vim.keymap.set(mode, lhs, rhs, opts)
                end

                map("n", "]c", function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "Next change" })

                map("n", "[c", function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return "<Ignore>"
                end, { expr = true, desc = "Previous change" })

                map({ "n", "x" }, "<leader>ga", ":Gitsigns stage_hunk<CR>", { desc = "Stage change" })
                map({ "n", "x" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Reset change" })

                map("n", "<leader>gA", gs.stage_buffer, { desc = "Stage buffer" })
                map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
                map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage change" })
                map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview change" })
            end,
        },
    },
}
