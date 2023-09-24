return {
    -- TODO: Add on_click telescope prompts
    -- TODO: Add attached LSP
    -- TODO: Add git blame to bottom right
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
                            -- FIXME: Change icons
                            error = " ",
                            warn = " ",
                            info = " ",
                            hint = " ",
                        },
                    },
                    {
                        "filetype",
                        padding = { left = 1, right = 0 },
                        icon_only = true,
                        separator = "",
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
                    { "filetype", icons_enabled = false },
                },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            -- TODO: Custom telescope extension?
            extensions = { "lazy", "man", "quickfix", "nvim-dap-ui" },
        },
        config = function(_, opts)
            vim.o.showmode = false
            require("lualine").setup(opts)
        end,
        dependencies = "nvim-tree/nvim-web-devicons",
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        -- TODO: Change icons
        opts = {
            window = {
                border = "rounded",
            },
        },
        config = function(_, opts)
            local whichkey = require("which-key")

            -- See https://github.com/folke/which-key.nvim/blob/main/lua/which-key/plugins/presets/init.lua
            local presets = require("which-key.plugins.presets")
            presets.operators["v"] = nil

            ---@type table<string, any>
            local keys = {
                mode = { "n", "v" },

                g = { name = "goto" },
                ["]"] = { name = "next" },
                ["["] = { name = "previous" },

                ["<leader>c"] = { name = "code" },
                ["<leader>d"] = { name = "debug" },
                ["<leader>f"] = { name = "find" },
                ["<leader>g"] = { name = "git" },
                ["<leader>h"] = { name = "help" },
                ["<leader>t"] = { name = "toggle" },
                ["<leader>u"] = { name = "ui" },
            }

            local ignore_keys =
                { "<C-r>", "u", "#", "*", "/", "?", "&", "£", "<C-d>", "<C-u>", "n", "N", "<C-l>", "Y" }
            for _, key in ipairs(ignore_keys) do
                keys[key] = "which_key_ignore"
            end

            whichkey.register(keys)

            whichkey.setup(opts)
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
        dependencies = "nvim-tree/nvim-web-devicons",
    },
    {
        -- ALTERNATIVE: notifier.nvim
        "rcarriga/nvim-notify",
        keys = {
            {
                "<leader>un",
                function()
                    require("notify").dismiss { silent = true, pending = true }
                end,
                desc = "Dismiss all notifications",
            },
        },
        opts = {
            stages = "fade",
            -- FIXME: Change icons
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
    -- Disable hlsearch when I move the cursor
    {
        "asiryk/auto-hlsearch.nvim",
        version = "1.0.0",
        event = "VeryLazy",
        config = true,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "VeryLazy",
        opts = {
            show_current_context = true,
            use_treesitter = true,
            buftype_exclude = { "terminal", "nofile" },
            filetype_exclude = {
                "help",
                "diff",
                "git",
                "checkhealth",
                "TelescopePrompt",
            },
        },
    },
    { "lukas-reineke/virt-column.nvim", event = "VimEnter", config = true },
}
