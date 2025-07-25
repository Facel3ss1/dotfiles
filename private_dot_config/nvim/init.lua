local lib = require("peter.lib")

-- Apply my config settings - this must be the very first thing we do
require("peter.config")

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    -- stylua: ignore start
    local out = vim.system(
        { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath },
        { text = true }
    ):wait()
    -- stylua: ignore end

    if out.code ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out.stderr, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- TODO: blamer.nvim?

-- Install and apply my plugin settings
require("lazy").setup("peter.plugins", {
    -- TODO: version = "*" to always use latest semver version
    defaults = { lazy = true },
    checker = {
        enabled = not lib.has_feature("win32"),
        notify = false,
    },
    change_detection = { notify = false },
    install = {
        colorscheme = { "catppuccin", "default" },
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "zipPlugin",
            },
        },
    },
    ui = {
        border = "rounded",
        backdrop = 100,
    },
})

-- TODO: health check for my config
-- TODO: --remote-ui ???
