---@module "lazy"
---@type LazySpec
return {
    -- FIXME: Replace, as it is archived
    {
        "stevearc/dressing.nvim",
        lazy = false,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load { plugins = { "dressing.nvim" } }
                return vim.ui.select(...)
            end

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
                get_config = function(opts)
                    if opts.kind == "grepprompt" then
                        return {
                            relative = "editor",
                        }
                    end
                end,
            },
            select = {
                get_config = function(opts)
                    if opts.kind == "codeaction" then
                        return {
                            telescope = require("telescope.themes").get_cursor(),
                        }
                    end
                end,
            },
        },
    },
}
