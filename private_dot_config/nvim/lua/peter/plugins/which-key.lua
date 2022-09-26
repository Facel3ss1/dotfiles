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
}, {prefix = "<leader>"})

whichkey.register {
    ["£"] = "which_key_ignore",
    ["<C-d>"] = "which_key_ignore",
    ["<C-u>"] = "which_key_ignore",
    ["n"] = "which_key_ignore",
    ["N"] = "which_key_ignore",
    ["<C-l>"] = "which_key_ignore",
    ["Y"] = "which_key_ignore",
}

whichkey.setup {}