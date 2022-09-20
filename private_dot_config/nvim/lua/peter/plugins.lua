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
        config = function() require("peter.config.theme") end,
    }

    -- use "tpope/vim-sleuth"

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
        config = function() require("peter.config.gitsigns") end,
    }
    use {
        "TimUntersberger/neogit",
        cmd = "Neogit",
        setup = require("peter.config.neogit").setup,
        config = require("peter.config.neogit").config,
        requires = "nvim-lua/plenary.nvim",
    }

    use {
        "nvim-lualine/lualine.nvim",
        event = "VimEnter",
        config = function() require("peter.config.lualine") end,
        requires = "kyazdani42/nvim-web-devicons",
    }
    use {
        "folke/which-key.nvim",
        event = "VimEnter",
        config = function() require("peter.config.which-key") end,
    }
    use {
        "rcarriga/nvim-notify",
        event = "VimEnter",
        config = function() require("peter.config.notify") end,
    }
    use {
        "stevearc/dressing.nvim",
        event = "VimEnter",
        config = function() require("peter.config.dressing") end,
    }
    use "j-hui/fidget.nvim"

    use {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    }

    use "folke/lua-dev.nvim"

    use {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        cmd = "Telescope",
        module = "telescope",
        setup = function() require("peter.config.telescope.keymap") end,
        config = function() require("peter.config.telescope") end,
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

    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-cmdline"
    use "dmitmel/cmp-cmdline-history"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-nvim-lsp"

    use {"L3MON4D3/LuaSnip", tag = "v1.*"}
    use "saadparwaiz1/cmp_luasnip"

    use "onsails/lspkind.nvim"

    use {
        "nvim-treesitter/nvim-treesitter",
        -- https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation#packernvim
        run = function() require("nvim-treesitter.install").update({with_sync = true}) end,
        event = "BufRead",
        module = "nvim-treesitter",
        config = function() require('peter.config.treesitter') end,
    }
    use {"nvim-treesitter/nvim-treesitter-context", after = "nvim-treesitter"}
end

require("peter.packer").setup(config, plugins)
