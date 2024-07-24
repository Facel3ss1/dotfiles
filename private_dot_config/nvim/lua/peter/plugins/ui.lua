local icons = require("peter.util.icons")

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
                    { "branch", icon = icons.git.branch },
                },
                lualine_c = {
                    {
                        "diagnostics",
                        symbols = {
                            hint = icons.diagnostics.HINT .. " ",
                            info = icons.diagnostics.INFO .. " ",
                            warn = icons.diagnostics.WARN .. " ",
                            error = icons.diagnostics.ERROR .. " ",
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
            extensions = {
                "lazy",
                "man",
                "quickfix",
                "nvim-dap-ui",
                "oil",
            },
        },
        config = function(_, opts)
            vim.o.showmode = false
            require("lualine").setup(opts)
        end,
        dependencies = "nvim-tree/nvim-web-devicons",
    },
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
                    { "[", group = "prev" },
                    { "]", group = "next" },
                    { "g", group = "goto" },
                    { "z", group = "fold" },
                },
            },
        },
    },
    {
        "akinsho/bufferline.nvim",
        version = "*",
        event = "VeryLazy",
        opts = {
            options = {
                mode = "tabs",
                always_show_bufferline = false,
                separator_style = "thick",
                buffer_close_icon = icons.ui.close,
                close_icon = icons.ui.close_box,
                modified_icon = icons.ui.dot,
                indicator = {
                    style = "none",
                },
            },
        },
        dependencies = "nvim-tree/nvim-web-devicons",
    },
    {
        "rcarriga/nvim-notify",
        version = "*",
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
            icons = icons.notifications,
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
        version = "*",
        event = "VeryLazy",
        config = true,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        event = "VeryLazy",
        main = "ibl",
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
