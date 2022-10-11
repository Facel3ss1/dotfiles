local whichkey = require("which-key")

whichkey.register({
    c = {
        name = "code"
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
}, {prefix = "<leader>"})

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
-- TODO: v shouldn't open menu
whichkey.setup {}
