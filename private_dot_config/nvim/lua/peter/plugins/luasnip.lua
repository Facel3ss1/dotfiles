local luasnip = require("luasnip")

luasnip.config.set_config {
    history = true,
    -- FIXME: Prevents us from jumping to a faraway snippet accidently?
    region_check_events = "CursorHold",
}

local map = require("peter.remap").bind({ "i", "s" }, { silent = true })

-- Tab will be the snippet expansion/jump key
map("<Tab>", function()
    if luasnip.expand_or_jumpable() then
        return "<Plug>luasnip-expand-or-jump"
    else
        return "<Tab>"
    end
end, { expr = true })

map("<S-Tab>", function()
    if luasnip.jumpable(-1) then
        return "<Cmd>lua require('luasnip').jump(-1)<CR>"
    else
        return "<S-Tab>"
    end
end, { expr = true })
