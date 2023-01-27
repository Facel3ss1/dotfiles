return {
    -- TODO: Add on_click telescope prompts
    {
        "nvim-lualine/lualine.nvim",
        event = "VimEnter",
        opts = {
            options = {
                globalstatus = true,
                section_separators = { left = "", right = "" },
                component_separators = { left = "|", right = "|" },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {
                    { "branch", icon = "" },
                },
                lualine_c = {
                    {
                        "diagnostics",
                        symbols = {
                            error = " ",
                            warn = " ",
                            info = " ",
                            hint = " ",
                        },
                    },
                    { "filename", path = 1 },
                },
                lualine_x = {
                    {
                        function()
                            local tabstop = vim.bo.tabstop
                            local shiftwidth = vim.fn.shiftwidth()
                            local expandtab = vim.bo.expandtab

                            if expandtab then
                                return string.format("spaces: %i", shiftwidth)
                            elseif shiftwidth == tabstop then
                                return string.format("tabs: %i", shiftwidth)
                            else
                                return string.format("tabs/spaces: %i/%i", tabstop, shiftwidth)
                            end
                        end,
                        cond = function()
                            -- TODO: gitcommit and NeogitCommitMessage
                            local should_hide = vim.bo.filetype == "help" or vim.bo.buftype == "terminal"
                            return not should_hide
                        end,
                    },
                    "encoding",
                    {
                        "fileformat",
                        symbols = {
                            unix = "lf",
                            dos = "crlf",
                            mac = "cr",
                        },
                        cond = function()
                            return vim.bo.buftype ~= "terminal"
                        end,
                    },
                    { "filetype", colored = false },
                },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            extensions = { "man", "quickfix" },
        },
        config = function(_, opts)
            vim.o.showmode = false
            require("lualine").setup(opts)
        end,
        dependencies = "kyazdani42/nvim-web-devicons",
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            local whichkey = require("which-key")

            -- See https://github.com/folke/which-key.nvim/blob/main/lua/which-key/plugins/presets/init.lua
            local presets = require("which-key.plugins.presets")
            presets.operators["v"] = nil

            whichkey.register({
                mode = { "n", "v" },
                c = {
                    name = "code",
                },
                f = {
                    name = "find",
                },
                g = {
                    name = "git",
                },
                h = {
                    name = "help",
                },
                t = {
                    name = "toggle",
                },
            }, { prefix = "<leader>" })

            whichkey.register {
                ["&"] = "which_key_ignore",
                ["£"] = "which_key_ignore",
                ["<C-d>"] = "which_key_ignore",
                ["<C-u>"] = "which_key_ignore",
                ["n"] = "which_key_ignore",
                ["N"] = "which_key_ignore",
                ["<C-l>"] = "which_key_ignore",
                ["Y"] = "which_key_ignore",
            }

            -- TODO: Change icons
            whichkey.setup {}
        end,
    },
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
        -- TODO: Dismiss keybind
        opts = {
            stages = "fade",
            icons = {
                DEBUG = "",
                ERROR = "",
                INFO = "",
                TRACE = "",
                WARN = "",
            },
        },
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.notify = function(...)
                return require("notify")(...)
            end
        end,
    },
    {
        "stevearc/dressing.nvim",
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
}
