-- Change leader to space
-- This is the first thing we do so that mappings from now on are set correctly
vim.g.mapleader = " "

require("peter.globals")
require("peter.config.autocommands")
require("peter.config.options")
require("peter.config.keymap")
require("peter.config.plugins")
