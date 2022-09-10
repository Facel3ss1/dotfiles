local ok, luasnip = pcall(require, "luasnip")
if not ok then
    return
end

luasnip.config.set_config {
    history = true,
}

local keymap = require("peter.keymap")
local map = keymap.bind({"i", "s"}, { silent = true })

-- Tab will be the snippet expansion/jump key
map("<Tab>", function()
    if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
    end
end)

map("<S-Tab>", function()
    if luasnip.jumpable(-1) then
        luasnip.jump(-1)
    end
end)
