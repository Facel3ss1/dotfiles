return {
    {
        "L3MON4D3/LuaSnip",
        version = "1.*",
        keys = {
            {
                "<Tab>",
                function()
                    return require("luasnip").expand_or_jumpable() and "<Plug>luasnip-expand-or-jump" or "<Tab>"
                end,
                mode = { "i", "s" },
                silent = true,
                expr = true,
            },
            {
                "<S-Tab>",
                function()
                    return require("luasnip").jumpable(-1) and "<Cmd>lua require('luasnip').jump(-1)<CR>" or "<S-Tab>"
                end,
                mode = { "i", "s" },
                silent = true,
                expr = true,
            },
        },
        opts = {
            history = true,
            delete_check_events = "TextChanged",
        },
        dependencies = {
            "rafamadriz/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
    },
}
