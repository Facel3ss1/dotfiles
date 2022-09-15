local ok, neogit = pcall(require, "neogit")
if not ok then
    return
end

local nnoremap = require("peter.keymap").nnoremap

nnoremap("<leader>gs", neogit.open, {desc = "Open Neogit status"})
nnoremap("<leader>gc", function() neogit.open {"commit"} end, {desc = "Commit"})

neogit.setup {
    disable_builtin_notifications = true,
    signs = {
        section = {"", ""},
        item = {"", ""},
    },
}
