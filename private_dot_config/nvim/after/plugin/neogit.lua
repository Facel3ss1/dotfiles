local neogit = require("neogit")
local nnoremap = require("peter.keymap").nnoremap

nnoremap("<leader>gs", neogit.open)
nnoremap("<leader>gc", function() neogit.open {"commit"} end)

neogit.setup {
    signs = {
        section = {"", ""},
        item = {"", ""},
    },
}
