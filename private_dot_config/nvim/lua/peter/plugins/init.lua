return {
    {
        "Shatur/neovim-ayu",
        lazy = false,
        priority = 1000,
        config = function()
            require("peter.plugins.theme")
        end,
    },
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
    { "tpope/vim-unimpaired", event = "VimEnter" },
    {
        "numToStr/Comment.nvim",
        keys = { "gc", "gb" },
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
        config = function()
            require("nvim-surround").setup {}
        end,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        -- TODO: Fix ``` in lua comments, disable `?
        -- TODO: Fix turbofish in rust
        config = function()
            require("nvim-autopairs").setup {}
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
        event = "VimEnter",
        config = function()
            require("peter.plugins.indent-blankline")
        end,
    },
    {
        "lukas-reineke/virt-column.nvim",
        event = "VimEnter",
        config = function()
            require("virt-column").setup()
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        config = function()
            require("peter.plugins.gitsigns")
        end,
    },
    {
        "TimUntersberger/neogit",
        cmd = "Neogit",
        init = require("peter.plugins.neogit").setup,
        config = require("peter.plugins.neogit").config,
        dependencies = "nvim-lua/plenary.nvim",
    },
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewFileHistory" },
        init = require("peter.plugins.diffview").setup,
        config = require("peter.plugins.diffview").config,
        dependencies = "nvim-lua/plenary.nvim",
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VimEnter",
        config = function()
            require("peter.plugins.lualine")
        end,
        dependencies = "kyazdani42/nvim-web-devicons",
    },
    {
        "akinsho/bufferline.nvim",
        version = "2.*",
        event = "VimEnter",
        config = function()
            require("peter.plugins.bufferline")
        end,
        dependencies = "kyazdani42/nvim-web-devicons",
    },
    {
        "folke/which-key.nvim",
        event = "VimEnter",
        config = function()
            require("peter.plugins.which-key")
        end,
    },
    {
        -- ALTERNATIVE: notifier.nvim
        "rcarriga/nvim-notify",
        event = "VimEnter",
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
        event = "VimEnter",
        config = function()
            require("peter.plugins.dressing")
        end,
    },
    -- It is not recommended to lazy load mason
    {
        "williamboman/mason.nvim",
        config = function()
            require("peter.plugins.mason")
        end,
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
                config = function()
                    require("fidget").setup {
                        text = {
                            spinner = "dots",
                            done = "",
                        },
                        timer = {
                            spinner_rate = 75,
                        },
                    }
                end,
            },
            {
                "kosayoda/nvim-lightbulb",
                config = function()
                    require("nvim-lightbulb").setup {
                        autocmd = {
                            enabled = true,
                        },
                    }

                    vim.fn.sign_define("LightBulbSign", { text = "", texthl = "LightBulbSign" })
                end,
            },
        },
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            require("peter.plugins.null-ls")
        end,
        dependencies = "nvim-lua/plenary.nvim",
    },
    "folke/neodev.nvim",
    {
        "simrat39/rust-tools.nvim",
        dependencies = "nvim-lua/plenary.nvim",
    },
    {
        "saecki/crates.nvim",
        version = "0.3.0",
        event = "BufRead Cargo.toml",
        config = function()
            require("peter.plugins.crates")
        end,
        dependencies = "nvim-lua/plenary.nvim",
    },
    { url = "https://git.sr.ht/~p00f/clangd_extensions.nvim" },
    {
        "Julian/lean.nvim",
        cond = vim.fn.executable("lean-language-server") == 1,
        ft = "lean3",
        config = function()
            require("lean").setup {
                abbreviations = { builtin = true },
                mappings = true,
            }
        end,
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
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        config = function()
            require("peter.plugins.cmp")
        end,
        dependencies = {
            "onsails/lspkind.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-cmdline",
            "dmitmel/cmp-cmdline-history",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
        },
    },
    {
        "L3MON4D3/LuaSnip",
        version = "1.*",
        config = function()
            require("peter.plugins.luasnip")
        end,
        dependencies = {
            "rafamadriz/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
    },
    -- TODO: nvim-ts-context-commentstring with lua help comments?
    -- TODO: nvim-ts-autotag
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = "VimEnter",
        config = function()
            require("peter.plugins.treesitter")
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter-context",
            "RRethy/nvim-treesitter-endwise",
        },
    },
    {
        "nvim-treesitter/playground",
        cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
    },
    { "dstein64/vim-startuptime", cmd = "StartupTime" },
}

-- TODO: See :h pack-add for why we need the bang
-- vim.cmd.packadd { "cfilter", bang = true }
