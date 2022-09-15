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
    }
}

local function plugins(use)
    -- Packer can manage itself as an optional plugin
    use {"wbthomason/packer.nvim", opt = true}

    use "Shatur/neovim-ayu"

    -- use "tpope/vim-sleuth"

    use "numToStr/Comment.nvim"
    use {
        "kylechui/nvim-surround",
        tag = "*",
        config = function() require("nvim-surround").setup {} end
    }
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }

    use "lukas-reineke/indent-blankline.nvim"
    use "lukas-reineke/virt-column.nvim"

    use "lewis6991/gitsigns.nvim"
    use {"TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim"}

    use {"nvim-lualine/lualine.nvim", requires = "kyazdani42/nvim-web-devicons"}
    use "folke/which-key.nvim"
    use "rcarriga/nvim-notify"
    use "stevearc/dressing.nvim"
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
        requires = "nvim-lua/plenary.nvim",
    }
    use {"nvim-telescope/telescope-fzf-native.nvim", run = "make"}
    use "nvim-telescope/telescope-file-browser.nvim"

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
