-- TODO: Make opt the default
local config = {
    auto_reload_compiled = false,
    preview_updates = true,
    profile = {
        enable = true,
        threshold = 0,
    },
    display = {
        working_sym = "",
        error_sym = "",
        done_sym = "",
        moved_sym = "",
    },
}

local function plugins(use)
    -- Packer can manage itself as an optional plugin
    use { "wbthomason/packer.nvim", opt = true }

    use {
        "Shatur/neovim-ayu",
        config = function()
            require("peter.plugins.theme")
        end,
    }

    -- TODO: vim-splitjoin, or nvim-trevJ
    -- TODO: vim-matchup
    -- TODO: toggleterm
    -- TODO: Highlight trailing whitespace
    -- TODO: dial.nvim
    -- TODO: nvim-semantic-tokens
    -- TODO: glow.nvim

    use { "tpope/vim-sleuth", event = "BufReadPre" }

    use {
        "numToStr/Comment.nvim",
        keys = { "gc", "gb" },
        config = function()
            require("Comment").setup {}

            local ft = require("Comment.ft")
            ft.set("lean3", { "--%s", "/-%s-/" })
        end,
    }
    use {
        "kylechui/nvim-surround",
        tag = "*",
        event = "BufReadPre",
        -- TODO: Surround with braces on new line?
        config = function()
            require("nvim-surround").setup {}
        end,
    }
    use {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        module = "nvim-autopairs",
        -- TODO: Fix ``` in lua comments, disable `?
        config = function()
            require("nvim-autopairs").setup {}
        end,
    }
    use {
        -- ALTERNATIVE: vim-wordmotion
        -- ALTERNATIVE: vim-textobj-variable-segment
        "bkad/CamelCaseMotion",
        event = "BufReadPre",
        setup = function()
            vim.g.camelcasemotion_key = "\\"
        end,
    }
    use {
        -- ALTERNATIVE: Do this myself (see https://gist.github.com/habamax/0a6c1d2013ea68adcf2a52024468752e)
        "stsewd/gx-extended.vim",
        keys = { "gx" },
        setup = function()
            vim.g["gxext#opencmd"] = "gx"
        end,
    }

    -- TODO: Highlight current indent level
    use { "lukas-reineke/indent-blankline.nvim", event = "BufReadPre" }
    use {
        "lukas-reineke/virt-column.nvim",
        event = "BufReadPre",
        config = function()
            require("virt-column").setup()
        end,
    }

    use {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        config = function()
            require("peter.plugins.gitsigns")
        end,
    }
    use {
        "TimUntersberger/neogit",
        cmd = "Neogit",
        module = "neogit",
        setup = require("peter.plugins.neogit").setup,
        config = require("peter.plugins.neogit").config,
        requires = "nvim-lua/plenary.nvim",
    }
    use {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewFileHistory" },
        module = "diffview",
        setup = require("peter.plugins.diffview").setup,
        config = require("peter.plugins.diffview").config,
        requires = "nvim-lua/plenary.nvim",
    }

    use {
        "nvim-lualine/lualine.nvim",
        event = "VimEnter",
        config = function()
            require("peter.plugins.lualine")
        end,
        requires = "kyazdani42/nvim-web-devicons",
    }
    use {
        "akinsho/bufferline.nvim",
        tag = "v2.*",
        event = "VimEnter",
        config = function()
            require("peter.plugins.bufferline")
        end,
        requires = "kyazdani42/nvim-web-devicons",
    }
    use {
        "folke/which-key.nvim",
        event = "VimEnter",
        config = function()
            require("peter.plugins.which-key")
        end,
    }
    use {
        "rcarriga/nvim-notify",
        event = "VimEnter",
        config = function()
            require("peter.plugins.notify")
        end,
    }
    use {
        "stevearc/dressing.nvim",
        event = "VimEnter",
        config = function()
            require("peter.plugins.dressing")
        end,
    }

    -- It is not recommended to lazy load mason
    use {
        "williamboman/mason.nvim",
        config = function()
            require("peter.plugins.mason")
        end,
    }
    use { "williamboman/mason-lspconfig.nvim", module = "mason-lspconfig" }
    use {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        module = "lspconfig",
        config = function()
            require("peter.plugins.lsp")
        end,
    }
    use {
        "jose-elias-alvarez/null-ls.nvim",
        module = "null-ls",
        config = function()
            require("peter.plugins.null-ls")
        end,
        requires = "nvim-lua/plenary.nvim",
    }

    use {
        "j-hui/fidget.nvim",
        after = "nvim-lspconfig",
        config = function()
            require("peter.plugins.fidget")
        end,
    }
    use {
        "kosayoda/nvim-lightbulb",
        after = "nvim-lspconfig",
        config = function()
            require("peter.plugins.lightbulb")
        end,
    }

    use { "folke/neodev.nvim", module = "neodev" }
    use {
        "https://git.sr.ht/~p00f/clangd_extensions.nvim",
        module = "clangd_extensions",
    }
    use {
        "Julian/lean.nvim",
        cond = vim.fn.executable("lean-language-server") == 1,
        ft = "lean3",
        config = function()
            require("lean").setup {
                abbreviations = { builtin = true },
                mappings = true,
            }
        end,
        requires = "nvim-lua/plenary.nvim",
    }

    use {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        cmd = "Telescope",
        module = "telescope",
        setup = function()
            require("peter.plugins.telescope.keymap")
        end,
        config = function()
            require("peter.plugins.telescope")
        end,
        requires = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                run = "make",
                cond = vim.fn.executable("make") == 1,
                module = "telescope._extensions.fzf",
            },
            { "nvim-telescope/telescope-file-browser.nvim", module = "telescope._extensions.file_browser" },
        },
    }

    use {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        module = "cmp",
        config = function()
            require("peter.plugins.cmp")
        end,
        requires = {
            { "onsails/lspkind.nvim", module = "lspkind" },
            { "hrsh7th/cmp-nvim-lsp", module = "cmp_nvim_lsp" },
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-cmdline",
            "dmitmel/cmp-cmdline-history",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
        },
    }

    use {
        "L3MON4D3/LuaSnip",
        tag = "v1.*",
        module = "luasnip",
        config = function()
            require("peter.plugins.luasnip")
        end,
        requires = {
            "rafamadriz/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
    }

    -- TODO: nvim-ts-context-commentstring with lua help comments?
    -- TODO: nvim-ts-autotag
    use {
        "nvim-treesitter/nvim-treesitter",
        -- https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation#packernvim
        run = function()
            require("nvim-treesitter.install").update { with_sync = true }
        end,
        event = "VimEnter",
        module = "nvim-treesitter",
        config = function()
            require("peter.plugins.treesitter")
        end,
    }
    use { "nvim-treesitter/nvim-treesitter-context", after = "nvim-treesitter" }
    use { "RRethy/nvim-treesitter-endwise", after = "nvim-treesitter" }
    use {
        "nvim-treesitter/playground",
        cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
    }

    use { "dstein64/vim-startuptime", cmd = "StartupTime" }
end

-- See :h pack-add for why we need the bang
vim.cmd.packadd { "cfilter", bang = true }

require("peter.packer").setup(config, plugins)
