local icons = require("peter.util.icons")

-- TODO: Add on_click telescope prompts
-- TODO: blamer.nvim?

---@module "lazy"
---@type LazySpec
return {
    {
        "echasnovski/mini.starter",
        version = "*",
        event = "VimEnter",
        -- stylua: ignore
        keys = {
            { "<leader>us", function() require("mini.starter").open() end, desc = "Open Starter" }
        },
        opts = function()
            local starter = require("mini.starter")

            return {
                silent = true,
                items = {
                    starter.sections.recent_files(5, true),
                    {
                        { name = "Oil", action = "Oil", section = "Actions" },
                        { name = "Lazy", action = "Lazy", section = "Actions" },
                        { name = "Mason", action = "Mason", section = "Actions" },
                        { name = "Edit new buffer", action = "enew", section = "Actions" },
                        { name = "Quit Neovim", action = "qall", section = "Actions" },
                    },
                },
                content_hooks = {
                    starter.gen_hook.adding_bullet(),
                    starter.gen_hook.aligning("center", "center"),
                },
                header = function()
                    local ascii_art_lines = {
                        [[            _           ]],
                        [[ _ ____   _(_)_ __ ___  ]],
                        [[| '_ \ \ / / | '_ ` _ \ ]],
                        [[| | | \ V /| | | | | | |]],
                        [[|_| |_|\_/ |_|_| |_| |_|]],
                    }

                    return vim.iter(ascii_art_lines):join("\n")
                end,
                footer = function()
                    ---@type vim.Version
                    local vim_version = vim.version()
                    -- Only show commit hash in prerelease builds
                    if not vim_version.prerelease then
                        vim_version.build = nil
                    end
                    local vim_version_string = string.format("nvim v%s", tostring(vim_version))

                    local footer_lines = {
                        vim_version_string,
                    }

                    return vim.iter(footer_lines):join("\n")
                end,
            }
        end,
    },
    {
        -- TODO: lsp_status component?
        "nvim-lualine/lualine.nvim",
        event = "VimEnter",
        opts = function()
            return {
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
                        "filetype",
                    },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                -- TODO: Custom telescope extension?
                extensions = {
                    "lazy",
                    "man",
                    "mason",
                    "quickfix",
                    "nvim-dap-ui",
                    "oil",
                },
            }
        end,
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
                    { "<leader>w", group = "window" },
                    { "[", group = "prev" },
                    { "]", group = "next" },
                    { "g", group = "goto" },
                    { "z", group = "fold" },
                },
            },
        },
    },
    {
        "rcarriga/nvim-notify",
        version = "*",
        lazy = false,
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
    {
        "mrjones2014/smart-splits.nvim",
        version = "*",
        lazy = false, -- It is recommended to not lazy load this plugin
        -- stylua: ignore
        keys = {
            { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move cursor to left window" },
            { "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Move cursor to down window" },
            { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move cursor to up window" },
            { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move cursor to right window" },

            { "<A-h>", function() require("smart-splits").resize_left() end, desc = "Resize window left" },
            { "<A-j>", function() require("smart-splits").resize_down() end, desc = "Resize window down" },
            { "<A-k>", function() require("smart-splits").resize_up() end, desc = "Resize window up" },
            { "<A-l>", function() require("smart-splits").resize_right() end, desc = "Resize window right" },

            { "<leader>wh", function() require("smart-splits").swap_buf_left() end, desc = "Swap window left" },
            { "<leader>wj", function() require("smart-splits").swap_buf_down() end, desc = "Swap window down" },
            { "<leader>wk", function() require("smart-splits").swap_buf_up() end, desc = "Swap window up" },
            { "<leader>wl", function() require("smart-splits").swap_buf_right() end, desc = "Swap window right" },
        },
        opts = {
            at_edge = "stop",
        },
    },
}
