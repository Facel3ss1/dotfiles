---@module "lazy"
---@type LazySpec
return {
    {
        "folke/which-key.nvim",
        version = "*",
        event = "VeryLazy",
        -- TODO: Change icons
        opts = {
            preset = "helix",
            spec = {
                {
                    mode = { "n", "v" },
                    { "<leader>c", group = "code" },
                    { "<leader>d", group = "debug" },
                    { "<leader>f", group = "find" },
                    { "<leader>g", group = "git" },
                    { "<leader>h", group = "help" },
                    { "<leader>t", group = "toggle" },
                    { "<leader>u", group = "ui" },
                    { "<leader>w", group = "window" },
                    { "[", group = "prev" },
                    { "]", group = "next" },
                    { "g", group = "goto" },
                    { "gr", group = "LSP actions" },
                    { "z", group = "fold" },
                },
            },
        },
    },
}
