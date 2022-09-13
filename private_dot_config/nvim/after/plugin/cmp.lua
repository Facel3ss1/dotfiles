local ok, cmp = pcall(require, "cmp")
if not ok then
    return
end

local luasnip = require("luasnip")

vim.opt.completeopt = { "menu", "menuone", "noselect" }

local has_autopairs = pcall(require, "nvim-autopairs")
if has_autopairs then
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end

local lspkind = require("lspkind")

cmp.setup {
    mapping = {
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.scroll_docs(4),
        ["<C-k>"] = cmp.mapping.scroll_docs(-4),
        ["<Esc>"] = cmp.mapping.close(),
        ["<C-c>"] = cmp.mapping.abort(),
        ["<Tab>"] = function(fallback)
            -- If we are in a snippet, require completions to be selected
            if luasnip.jumpable(1) and luasnip.in_snippet() then
                if cmp.get_selected_entry() then
                    cmp.confirm({select = false})
                else
                    luasnip.jump(1)
                end
            elseif not cmp.confirm({select = true}) then
                fallback()
            end
        end,
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

cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources ({
        { name = "buffer" },
    }, {
        { name = "cmdline_history" },
    })
})

-- FIXME: This hangs when I type !, only when cmdline is enabled
-- cmp.setup.cmdline(":", {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = cmp.config.sources({
--         { name = "path" },
--     }, {
--         { name = "cmdline" },
--     }, {
--         { name = "buffer" },
--     }, {
--         { name = "cmdline_history" },
--     })
-- })
