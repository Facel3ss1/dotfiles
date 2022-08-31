-- bootstrap packer
local fn = vim.fn
local install_path = fn.stdpath("data").."site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
end

return require("packer").startup(function(use)
    use "wbthomason/packer.nvim"

    use "ayu-theme/ayu-vim"

    -- use "tpope/vim-sensible"
    -- use "tpope/vim-surround"
    -- use "tpope/vim-commentary"
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

    use "jeffkreeftmeijer/vim-numbertoggle"
    use "lukas-reineke/indent-blankline.nvim"
    use {
        "lewis6991/gitsigns.nvim",
        config = function() require("gitsigns").setup() end
    }

    use {"kyazdani42/nvim-tree.lua", requires = "kyazdani42/nvim-web-devicons"}
    use {"nvim-lualine/lualine.nvim", requires = "kyazdani42/nvim-web-devicons"}

    use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}

    if packer_bootstrap then
        require("packer").sync()
    end
end)
