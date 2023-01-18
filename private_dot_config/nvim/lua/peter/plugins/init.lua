return {
    { import = "peter.plugins.colorscheme" },
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
    {
        "tpope/vim-sleuth",
        cmd = "Sleuth",
        event = "BufReadPre",
    },
    { "tpope/vim-unimpaired", event = "VeryLazy" },
    {
        "numToStr/Comment.nvim",
        keys = {
            { "gc", desc = "Line comment" },
            { "gb", desc = "Block comment" },
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
    {
        "lukas-reineke/virt-column.nvim",
        event = "VimEnter",
        config = true,
    },
    { import = "peter.plugins.gitsigns" },
    { import = "peter.plugins.neogit" },
    { import = "peter.plugins.diffview" },
    { import = "peter.plugins.lualine" },
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
    { import = "peter.plugins.which-key" },
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
    -- It is not recommended to lazy load mason
    {
        "williamboman/mason.nvim",
        -- TODO: Automatically update installed packages
        -- TODO: Ensure stylua is installed?
        opts = {
            ui = {
                border = "rounded",
                icons = {
                    package_installed = "",
                    package_pending = "",
                    package_uninstalled = "●",
                },
            },
        },
    },
    "williamboman/mason-lspconfig.nvim",
    {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        config = function()
            require("peter.plugins.lsp")
        end,
        dependencies = {
            {
                "j-hui/fidget.nvim",
                opts = {
                    text = {
                        spinner = "dots",
                        done = "",
                    },
                    timer = {
                        spinner_rate = 75,
                    },
                },
            },
            {
                "kosayoda/nvim-lightbulb",
                opts = {
                    autocmd = {
                        enabled = true,
                    },
                },
                config = function(_, opts)
                    require("nvim-lightbulb").setup(opts)
                    vim.fn.sign_define("LightBulbSign", { text = "", texthl = "LightBulbSign" })
                end,
            },
        },
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        opts = function()
            local null_ls = require("null-ls")

            return {
                sources = {
                    null_ls.builtins.formatting.fish_indent,
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.diagnostics.fish,
                },
            }
        end,
        dependencies = "nvim-lua/plenary.nvim",
    },
    "folke/neodev.nvim",
    {
        "simrat39/rust-tools.nvim",
        cond = vim.fn.executable("rust-analyzer") == 1,
        dependencies = "nvim-lua/plenary.nvim",
    },
    { import = "peter.plugins.crates" },
    { url = "https://git.sr.ht/~p00f/clangd_extensions.nvim" },
    {
        "Julian/lean.nvim",
        cond = vim.fn.executable("lean-language-server") == 1,
        ft = "lean3",
        opts = {
            abbreviations = { builtin = true },
            mappings = true,
        },
        dependencies = "nvim-lua/plenary.nvim",
    },
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        cmd = "Telescope",
        init = function()
            require("peter.plugins.telescope.keymap")
        end,
        config = function()
            require("peter.plugins.telescope")
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = vim.fn.executable("make") == 1,
            },
            "nvim-telescope/telescope-file-browser.nvim",
        },
    },
    { import = "peter.plugins.cmp" },
    { import = "peter.plugins.luasnip" },
    { import = "peter.plugins.treesitter" },
    { "dstein64/vim-startuptime", cmd = "StartupTime" },
}

-- TODO: See :h pack-add for why we need the bang
-- vim.cmd.packadd { "cfilter", bang = true }
