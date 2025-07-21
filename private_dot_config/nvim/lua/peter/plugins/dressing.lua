---@module "lazy"
---@type LazySpec
return {
    -- FIXME: Replace, as it is archived
    {
        "stevearc/dressing.nvim",
        lazy = false,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load { plugins = { "dressing.nvim" } }
                return vim.ui.input(...)
            end
        end,
        opts = {
            input = {
                win_options = {
                    winblend = 0,
                },
            },
            select = {
                enabled = false,
            },
        },
    },
}
