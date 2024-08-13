local icons = require("peter.util.icons")

-- TODO: Add on_click telescope prompts
-- TODO: Add attached LSP
-- TODO: blamer.nvim?

---@module "lazy"
---@type LazySpec
return {
    {
        "echasnovski/mini.starter",
        version = "*",
        event = "VimEnter",
        opts = function()
            local starter = require("mini.starter")

            ---@param content any
            ---@param buf integer
            ---@return any
            local function autocommands_hook(content, buf)
                local refresh_group = vim.api.nvim_create_augroup("RefreshMiniStarter", { clear = true })

                -- Refresh every time lazy loads a plugin
                vim.api.nvim_create_autocmd("User", {
                    group = refresh_group,
                    pattern = "LazyLoad",
                    callback = function()
                        starter.refresh(buf)
                    end,
                    desc = "Refresh mini.starter",
                })

                -- Refresh 0.5s after startup to catch any plugin updates
                vim.api.nvim_create_autocmd("User", {
                    group = refresh_group,
                    pattern = "VeryLazy",
                    callback = function()
                        vim.defer_fn(function()
                            starter.refresh(buf)
                        end, 500)
                    end,
                    desc = "Refresh mini.starter after 0.5s",
                })

                -- Ensure that starter window is centered when it is focused
                vim.api.nvim_create_autocmd("BufEnter", {
                    group = refresh_group,
                    buffer = buf,
                    callback = function()
                        starter.refresh(buf)
                    end,
                    desc = "Refresh mini.starter",
                })

                return content
            end

            return {
                silent = true,
                items = {
                    starter.sections.recent_files(5, false),
                    {
                        { name = "Lazy", action = "Lazy", section = "Actions" },
                        { name = "Mason", action = "Mason", section = "Actions" },
                        { name = "Edit new buffer", action = "enew", section = "Actions" },
                        { name = "Quit Neovim", action = "qall", section = "Actions" },
                    },
                },
                content_hooks = {
                    starter.gen_hook.adding_bullet(),
                    starter.gen_hook.aligning("center", "center"),
                    autocommands_hook,
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

                    local lazy_stats = require("lazy").stats()
                    local plugins_string = string.format("%d/%d plugins loaded", lazy_stats.loaded, lazy_stats.count)

                    local lazy_status = require("lazy.status")
                    if lazy_status.has_updates() then
                        -- Extract the number of updates from the lazy statusline string
                        local num_updates_string = lazy_status.updates():gsub(".+(%d+)$", "%1")
                        local num_updates = tonumber(num_updates_string)

                        if num_updates > 0 then
                            local updates_pluralised = num_updates > 1 and "updates" or "update"
                            plugins_string =
                                string.format("%s, %d %s available", plugins_string, num_updates, updates_pluralised)
                        end
                    end

                    local footer_lines = {
                        plugins_string,
                        "",
                        vim_version_string,
                    }

                    return vim.iter(footer_lines):join("\n")
                end,
            }
        end,
    },
    {
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
        opts = function()
            return {
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
                highlights = require("catppuccin.groups.integrations.bufferline").get(),
            }
        end,
        dependencies = "nvim-tree/nvim-web-devicons",
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
}
