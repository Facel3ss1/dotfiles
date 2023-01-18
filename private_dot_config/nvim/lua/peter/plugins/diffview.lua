return {
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewFileHistory" },
        keys = {
            { "<leader>gd", "<Cmd>DiffviewOpen<CR>", desc = "Open diff view" },
            { "<leader>gh", "<Cmd>DiffviewFileHistory<CR>", desc = "Open history" },
            { "<leader>gH", "<Cmd>DiffviewFileHistory %<CR>", desc = "Open file history" },
            { "<leader>gH", ":DiffviewFileHistory %<CR>", mode = "x", silent = true, desc = "Open history for range" },
        },
        opts = {
            enhanced_diff_hl = true,
            signs = {
                done = "",
            },
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
        },
        dependencies = "nvim-lua/plenary.nvim",
    },
}
