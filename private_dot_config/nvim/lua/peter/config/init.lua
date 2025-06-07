-- Map the leaders first so that mappings from now on are set correctly
vim.g.mapleader = vim.keycode("<Space>")
vim.g.maplocalleader = vim.keycode("<Space><Space>")

require("peter.config.options")
require("peter.config.autocommands")
require("peter.config.keymap")
require("peter.config.diagnostics")
require("peter.config.chezmoi")
