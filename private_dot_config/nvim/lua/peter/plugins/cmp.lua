local cmp = require("cmp")
local lspkind = require("lspkind")

vim.opt.completeopt = { "menu", "menuone", "noselect" }

cmp.setup {
    mapping = {
        -- :h ins-completion and :h ins-completion-menu
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-y>"] = cmp.mapping.confirm { select = true },
        ["<C-Space>"] = cmp.mapping.complete(),
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "luasnip" },
    }, {
        { name = "buffer" },
    }),
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    formatting = {
        format = lspkind.cmp_format {
            mode = "symbol_text",
            menu = {
                buffer = "[buf]",
                nvim_lsp = "[lsp]",
                path = "[path]",
                luasnip = "[snip]",
                cmdline = "[cmd]",
                cmdline_history = "[hist]",
            },
        },
    },
}

cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "buffer" },
    }, {
        { name = "cmdline_history" },
    }),
})

-- TODO: gitcommit completions

-- cmp.setup.cmdline(":", {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = cmp.config.sources({
--         { name = "path" },
--     }, {
--         -- HACK: This is a workaround for https://github.com/hrsh7th/cmp-cmdline/issues/24
--         -- When I'm on WSL and I type !, it tries to enumerate my windows path
--         -- as well as my linux path, which is sloooooow and it hanged nvim. So
--         -- I use this regex thing from the above issue to alleviate that (it
--         -- doesn't work in all cases, but it's better than nothing).
--         -- { name = "cmdline", keyword_pattern = [=[[^[:blank:]\!]*]=] },
--     }, {
--         { name = "cmdline_history" },
--     }, {
--         { name = "buffer" },
--     }),
-- })

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
