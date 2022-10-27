-- Map the leaders first so that mappings from now on are set correctly
vim.g.mapleader = " " -- <Space>
vim.g.maplocalleader = "  " -- <Space><Space>

require("peter.globals")
require("peter.config.autocommands")
require("peter.config.options")
require("peter.config.keymap")
require("peter.config.plugins")

-- TODO: Central place for icons
-- TODO: executable() utility function
-- TODO: health check for my config
-- TODO: spell checks
