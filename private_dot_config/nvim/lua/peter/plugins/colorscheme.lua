---@module "lazy"
---@type LazySpec
return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        version = "*",
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
                blink_cmp = true,
                dap = true,
                dap_ui = true,
                indent_blankline = {
                    enabled = true,
                },
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
                nvim_surround = true,
                telescope = {
                    enabled = true,
                },
                treesitter = true,
                treesitter_context = true,
                which_key = true,
            },
            custom_highlights = function(colors)
                return {
                    WinSeparator = { fg = colors.overlay0 },
                }
            end,
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin")
        end,
    },
}
