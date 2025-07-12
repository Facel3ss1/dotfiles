---@module "lazy"
---@type LazySpec
return {
    -- TODO: vim-matchup
    -- TODO: vim-splitjoin, or treesj
    -- TODO: dial.nvim
    {
        "Saghen/blink.cmp",
        version = "*",
        event = { "InsertEnter", "CmdlineEnter" },
        ---@module "blink.cmp"
        ---@type blink.cmp.Config
        opts = {
            -- See `:h ins-completion`
            keymap = { preset = "default" },
            completion = {
                documentation = { auto_show = true },
                menu = {
                    draw = { treesitter = { "lsp" } },
                },
            },
            sources = {
                per_filetype = {
                    lua = { inherit_defaults = true, "lazydev" },
                },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100, -- Show at higher priority than lsp source
                    },
                },
            },
        },
        config = true,
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "BufReadPre",
        -- TODO: keys
        -- TODO: Surround with braces on new line?
        config = true,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        -- TODO: Fix ``` in lua comments, disable `?
        -- TODO: Fix turbofish in rust
        config = true,
    },
    {
        -- ALTERNATIVE: vim-wordmotion
        -- ALTERNATIVE: vim-textobj-variable-segment
        "bkad/CamelCaseMotion",
        event = "VeryLazy",
        init = function()
            vim.g.camelcasemotion_key = [[\]]
        end,
    },
}
