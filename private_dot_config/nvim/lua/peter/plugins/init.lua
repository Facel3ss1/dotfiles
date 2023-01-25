return {
    -- TODO: vim-splitjoin, or nvim-trevJ
    -- TODO: lsp_signature.nvim?
    -- TODO: inc-rename.nvim
    -- TODO: todo-comments
    -- TODO: vim-matchup
    -- TODO: Highlight trailing whitespace
    -- TODO: dial.nvim
    -- TODO: hl-args with lua exlude self and use and/or nvim-semantic-tokens
    -- TODO: glow.nvim
    -- TODO: Use other events as well as BufReadPre?
    { "tpope/vim-sleuth", cmd = "Sleuth", event = "BufReadPre" },
    { "tpope/vim-unimpaired", event = "VeryLazy" },
    {
        "numToStr/Comment.nvim",
        keys = {
            { "gc", mode = { "n", "v" }, desc = "Line comment" },
            { "gb", mode = { "n", "v" }, desc = "Block comment" },
        },
        config = function()
            require("Comment").setup {}

            local ft = require("Comment.ft")
            ft.set("lean3", { "--%s", "/-%s-/" })
        end,
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
        config = function()
            require("nvim-autopairs").setup {}
            require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
        end,
    },
    {
        -- ALTERNATIVE: vim-wordmotion
        -- ALTERNATIVE: vim-textobj-variable-segment
        "bkad/CamelCaseMotion",
        event = "BufReadPre",
        init = function()
            vim.g.camelcasemotion_key = [[\]]
        end,
    },
    {
        -- ALTERNATIVE: Do this myself (see https://gist.github.com/habamax/0a6c1d2013ea68adcf2a52024468752e)
        "stsewd/gx-extended.vim",
        keys = { "gx" },
        init = function()
            vim.g["gxext#opencmd"] = "gx"
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "VeryLazy",
        opts = {
            show_current_context = true,
            buftype_exclude = { "terminal", "nofile" },
            filetype_exclude = {
                "help",
                "diff",
                "git",
                "checkhealth",
            },
        },
    },
    { "lukas-reineke/virt-column.nvim", event = "VimEnter", config = true },
    {
        "akinsho/bufferline.nvim",
        version = "2.*",
        event = "VeryLazy",
        opts = {
            options = {
                mode = "tabs",
                always_show_bufferline = false,
                separator_style = "thick",
                indicator = {
                    style = "none",
                },
            },
        },
        dependencies = "kyazdani42/nvim-web-devicons",
    },
    {
        -- ALTERNATIVE: notifier.nvim
        "rcarriga/nvim-notify",
        event = "VimEnter",
        -- TODO: Dismiss keybind
        config = function()
            local notify = require("notify")

            notify.setup {
                stages = "fade",
                icons = {
                    DEBUG = "",
                    ERROR = "",
                    INFO = "",
                    TRACE = "",
                    WARN = "",
                },
            }

            vim.notify = notify
        end,
    },
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        opts = {
            input = {
                insert_only = false,
                win_options = {
                    winblend = 0,
                },
                get_config = function(opts)
                    if opts.kind == "grepprompt" then
                        return {
                            insert_only = true,
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
    { "dstein64/vim-startuptime", cmd = "StartupTime" },
}

-- TODO: See :h pack-add for why we need the bang
-- vim.cmd.packadd { "cfilter", bang = true }
