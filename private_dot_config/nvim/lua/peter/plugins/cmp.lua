return {
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        opts = function()
            local cmp = require("cmp")

            return {
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
                    format = require("lspkind").cmp_format {
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
        end,
        config = function(_, opts)
            local cmp = require("cmp")

            vim.opt.completeopt = { "menu", "menuone", "noselect" }

            cmp.setup(opts)

            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "buffer" },
                }, {
                    { name = "cmdline_history" },
                }),
            })

            -- TODO: gitcommit completions

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }, {
                    { name = "cmdline_history" },
                }, {
                    { name = "buffer" },
                }),
            })
        end,
        dependencies = {
            "onsails/lspkind.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-cmdline",
            "dmitmel/cmp-cmdline-history",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
        },
    },
}
