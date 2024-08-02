---@module "lazy"
---@type LazySpec
return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        ---@type CatppuccinOptions
        opts = {
            background = {
                dark = "macchiato",
            },
            term_colors = true,
            styles = {
                conditionals = {},
            },
            default_integrations = false,
            integrations = {
                cmp = true,
                dap = true,
                dap_ui = true,
                diffview = true,
                fidget = true,
                gitsigns = true,
                indent_blankline = {
                    enabled = true,
                },
                mason = true,
                mini = {
                    enabled = true,
                },
                native_lsp = {
                    enabled = true,
                    virtual_text = {},
                    underlines = {
                        errors = { "undercurl" },
                        warnings = { "undercurl" },
                        information = { "undercurl" },
                        hints = { "underline" },
                        ok = { "underline" },
                    },
                    inlay_hints = {
                        background = false,
                    },
                },
                notify = true,
                nvim_surround = true,
                telescope = {
                    enabled = true,
                },
                treesitter = true,
                treesitter_context = true,
                which_key = true,
            },
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin")
        end,
    },
}
