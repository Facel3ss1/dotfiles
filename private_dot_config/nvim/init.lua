-- Map the leaders first so that mappings from now on are set correctly
vim.g.mapleader = " " -- <Space>
vim.g.maplocalleader = "  " -- <Space><Space>

require("peter.config.autocommands")
require("peter.config.options")
require("peter.config.keymap")
require("peter.config.chezmoi")

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

vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    group = vim.api.nvim_create_augroup("LazyPackadd", { clear = true }),
    callback = function()
        -- :h pack-add says we need a bang, but this doesn't load the plugin,
        -- it only adds the files to 'runtimepath' - given that lazy.nvim is
        -- managing the runtimepath lets just add it normally.
        vim.cmd.packadd { "cfilter" }
    end,
    desc = "Run :packadd cfilter",
})

require("lazy").setup("peter.plugins", {
    defaults = { lazy = true },
    checker = {
        enabled = not (vim.fn.has("win32") == 1),
    },
    change_detection = { notify = false },
    install = {
        colorscheme = { "ayu-mirage", "habamax" },
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "matchit",
                "tohtml",
            },
        },
    },
    ui = {
        border = "rounded",
    },
    diff = {
        cmd = "diffview.nvim",
    },
})

-- TODO: Central place for icons
-- TODO: executable() and has() utility functions
-- TODO: health check for my config
-- TODO: --remote-ui ???
