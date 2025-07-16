---@module "lazy"
---@type LazySpec
return {
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "VeryLazy",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {
            scope = {
                show_start = false,
                show_end = false,
                include = {
                    node_type = {
                        ["*"] = { "*" },
                    },
                },
            },
            exclude = {
                filetypes = {
                    "help",
                    "diff",
                    "git",
                    "checkhealth",
                    "TelescopePrompt",
                },
                buftypes = {
                    "terminal",
                    "nofile",
                },
            },
        },
    },
}
