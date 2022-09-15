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

whichkey.setup {}
