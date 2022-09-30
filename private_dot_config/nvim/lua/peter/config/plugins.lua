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
    use {"wbthomason/packer.nvim", opt = true}

    use {
        "Shatur/neovim-ayu",
        config = function() require("peter.plugins.theme") end,
    }

    -- TODO: vim-splitjoin, or nvim-trevJ
    -- TODO: nvim-ts-context-commentstring with lua help comments?
    -- TODO: vim-matchup
    -- TODO: toggleterm
    -- TODO: Highlight trailing whitespace

    use {"tpope/vim-sleuth", event = "BufReadPre"}

    use {
        "numToStr/Comment.nvim",
        keys = {"gc", "gb"},
        config = function() require("Comment").setup {} end,
    }
    use {
        "kylechui/nvim-surround",
        tag = "*",
        event = "BufReadPre",
        -- TODO: Surround with braces on new line?
        config = function() require("nvim-surround").setup {} end,
    }
    use {
        "windwp/nvim-autopairs",
        module = "nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end,
    }

    use {"lukas-reineke/indent-blankline.nvim", event = "BufReadPre"}
    use {
        "lukas-reineke/virt-column.nvim",
        event = "BufReadPre",
        config = function() require("virt-column").setup() end,
    }

    use {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        config = function() require("peter.plugins.gitsigns") end,
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
        cmd = {"DiffviewOpen", "DiffviewFileHistory"},
        module = "diffview",
        setup = require("peter.plugins.diffview").setup,
        config = require("peter.plugins.diffview").config,
        requires = "nvim-lua/plenary.nvim",
    }

    use {
        "nvim-lualine/lualine.nvim",
        event = "VimEnter",
        config = function() require("peter.plugins.lualine") end,
        requires = "kyazdani42/nvim-web-devicons",
    }
    use {
        "folke/which-key.nvim",
        event = "VimEnter",
        config = function() require("peter.plugins.which-key") end,
    }
    use {
        "rcarriga/nvim-notify",
        event = "VimEnter",
        config = function() require("peter.plugins.notify") end,
    }
    use {
        "stevearc/dressing.nvim",
        event = "VimEnter",
        config = function() require("peter.plugins.dressing") end,
    }

    -- It is not recommended to lazy load mason
    use {
        "williamboman/mason.nvim",
        config = function() require("peter.plugins.mason") end,
    }
    use {"williamboman/mason-lspconfig.nvim", module = "mason-lspconfig"}
    use {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        config = function() require("peter.plugins.lsp") end,
    }
    use {
        "j-hui/fidget.nvim",
        after = "nvim-lspconfig",
        config = function() require("peter.plugins.fidget") end,
    }

    use {"folke/lua-dev.nvim", module = "lua-dev"}

    use {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        cmd = "Telescope",
        module = "telescope",
        setup = function() require("peter.plugins.telescope.keymap") end,
        config = function() require("peter.plugins.telescope") end,
        requires = {
            "nvim-lua/plenary.nvim",
            "kyazdani42/nvim-web-devicons",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                run = "make",
                cond = vim.fn.executable("make") == 1,
                module = "telescope._extensions.fzf",
            },
            {"nvim-telescope/telescope-file-browser.nvim", module = "telescope._extensions.file_browser"},
        },
    }

    use {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        module = "cmp",
        config = function() require("peter.plugins.cmp") end,
        requires = {
            {"onsails/lspkind.nvim", module = "lspkind"},
            {"hrsh7th/cmp-nvim-lsp", module = "cmp_nvim_lsp"},
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
        config = function() require("peter.plugins.luasnip") end,
        requires = {
            "rafamadriz/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
    }

    use {
        "nvim-treesitter/nvim-treesitter",
        -- https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation#packernvim
        run = function() require("nvim-treesitter.install").update({with_sync = true}) end,
        event = "VimEnter",
        config = function() require('peter.plugins.treesitter') end,
        requires = {
            {"nvim-treesitter/nvim-treesitter-context", after = "nvim-treesitter"},
        },
    }
end

-- See :h pack-add for why we need the !
vim.cmd("packadd! cfilter")

require("peter.packer").setup(config, plugins)
