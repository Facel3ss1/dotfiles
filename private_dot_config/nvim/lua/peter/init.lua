-- Map the leaders first so that mappings from now on are set correctly
vim.g.mapleader = " " -- <Space>
vim.g.maplocalleader = "  " -- <Space><Space>

require("peter.globals")
require("peter.config.autocommands")
require("peter.config.options")
require("peter.config.keymap")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(require("peter.plugins"), {
    defaults = { lazy = true },
    ui = {
        border = "rounded",
    },
})

-- TODO: Central place for icons
-- TODO: executable() utility function
-- TODO: health check for my config
-- TODO: spell checks
