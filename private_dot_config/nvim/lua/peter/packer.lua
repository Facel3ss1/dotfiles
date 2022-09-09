-- bootstrap packer
local fn = vim.fn
local install_path = fn.stdpath("data").."site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
end

return require("packer").startup {
    function(use)
        use "wbthomason/packer.nvim"

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

        use {"kyazdani42/nvim-tree.lua", requires = "kyazdani42/nvim-web-devicons"}
        use {"nvim-lualine/lualine.nvim", requires = "kyazdani42/nvim-web-devicons"}
        use "folke/which-key.nvim"
        use "rcarriga/nvim-notify"

        use {
            "nvim-telescope/telescope.nvim",
            branch = "0.1.x",
            requires = "nvim-lua/plenary.nvim",
        }
        use {"nvim-telescope/telescope-fzf-native.nvim", run = "make"}

        use "hrsh7th/nvim-cmp"
        use "hrsh7th/cmp-cmdline"
        use "dmitmel/cmp-cmdline-history"
        use "hrsh7th/cmp-buffer"
        use "hrsh7th/cmp-emoji"
        use "hrsh7th/cmp-path"
        use "hrsh7th/cmp-nvim-lua"

        use {"L3MON4D3/LuaSnip", tag = "v1.*"}
        use "saadparwaiz1/cmp_luasnip"

        use "onsails/lspkind.nvim"

        use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}

        if packer_bootstrap then
            require("packer").sync()
        end
    end,
    config = {
        preview_updates = true,
    }
}
