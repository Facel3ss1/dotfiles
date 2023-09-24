local icons = require("peter.util.icons")

-- TODO: git-conflict.nvim?
return {
    -- TODO: Would ]c etc. be possible?
    {
        "NeogitOrg/neogit",
        cmd = "Neogit",
        keys = {
            { "<leader>gs", "<Cmd>Neogit<CR>", desc = "Open Neogit status" },
            { "<leader>gc", "<Cmd>Neogit commit<CR>", desc = "Commit" },
        },
        opts = {
            disable_builtin_notifications = true,
            signs = {
                section = { icons.ui.collapsed, icons.ui.expanded },
                item = { icons.ui.collapsed, icons.ui.expanded },
            },
            remember_settings = false,
            integrations = {
                diffview = true,
            },
        },
        dependencies = "nvim-lua/plenary.nvim",
        config = true,
    },
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
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewFileHistory" },
        keys = {
            { "<leader>gd", "<Cmd>DiffviewOpen<CR>", desc = "Open diff view" },
            { "<leader>gh", "<Cmd>DiffviewFileHistory %<CR>", desc = "Open file history" },
            { "<leader>gh", ":DiffviewFileHistory %<CR>", mode = "x", silent = true, desc = "Open history for range" },
            { "<leader>gH", "<Cmd>DiffviewFileHistory<CR>", desc = "Open commit history" },
        },
        opts = {
            enhanced_diff_hl = true,
            signs = {
                done = icons.ui.done,
            },
            -- TODO
            keymaps = {
                file_panel = {
                    ["q"] = "<Cmd>DiffviewClose<CR>",
                },
                file_history_panel = {
                    ["q"] = "<Cmd>DiffviewClose<CR>",
                },
                view = {
                    ["q"] = "<Cmd>DiffviewClose<CR>",
                },
            },
            -- TODO
            -- view = {
            --     merge_tool = {
            --         layout = "diff4_mixed",
            --     },
            -- },
        },
        dependencies = "nvim-lua/plenary.nvim",
    },
}
