local whichkey = require("which-key")

-- See https://github.com/folke/which-key.nvim/blob/main/lua/which-key/plugins/presets/init.lua
local presets = require("which-key.plugins.presets")
presets.operators["v"] = nil

whichkey.register({
    c = {
        name = "code",
    },
    f = {
        name = "find",
    },
    g = {
        name = "git",
    },
    h = {
        name = "help",
    },
    t = {
        name = "toggle",
    },
}, { prefix = "<leader>" })

whichkey.register {
    ["&"] = "which_key_ignore",
    ["£"] = "which_key_ignore",
    ["<C-d>"] = "which_key_ignore",
    ["<C-u>"] = "which_key_ignore",
    ["n"] = "which_key_ignore",
    ["N"] = "which_key_ignore",
    ["<C-l>"] = "which_key_ignore",
    ["Y"] = "which_key_ignore",
}

-- TODO: Change icons
whichkey.setup {}
