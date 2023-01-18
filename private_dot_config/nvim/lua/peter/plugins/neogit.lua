-- TODO: Would ]c etc. be possible?
return {
    {
        "TimUntersberger/neogit",
        cmd = "Neogit",
        keys = {
            { "<leader>gs", "<Cmd>Neogit<CR>", desc = "Open Neogit status" },
            { "<leader>gc", "<Cmd>Neogit commit<CR>", desc = "Commit" },
        },
        opts = {
            disable_builtin_notifications = true,
            signs = {
                section = { "", "" },
                item = { "", "" },
            },
            integrations = {
                diffview = true,
            },
        },
        dependencies = "nvim-lua/plenary.nvim",
    },
}
