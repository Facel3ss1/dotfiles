-- Change leader to space
-- This is the first thing we do so that mappings from now on are set correctly
vim.g.mapleader = " "

-- TODO: Central place for icons

require("peter.globals")
require("peter.config.autocommands")
require("peter.config.options")
require("peter.config.keymap")
require("peter.config.plugins")

-- TODO: Configure gx for WSL using wsl-open
-- TODO: health check for my config
-- TODO: spell checks
