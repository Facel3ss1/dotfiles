return {
    -- TODO: vim-matchup
    -- TODO: vim-splitjoin, or treesj
    -- TODO: Highlight trailing whitespace (mini.trailspace), see :h editorconfig and Primeagen's config for trimming
    -- TODO: dial.nvim
    {
        -- TODO: nvim-cmp-emoji
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
                sources = cmp.config.sources {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                    { name = "buffer" },
                },
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
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
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
            region_check_events = "InsertEnter",
            delete_check_events = "TextChanged,InsertLeave",
        },
        dependencies = {
            "rafamadriz/friendly-snippets",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
        },
    },
    {
        "numToStr/Comment.nvim",
        keys = {
            { "gc", mode = { "n", "v" }, desc = "Line comment" },
            { "gb", mode = { "n", "v" }, desc = "Block comment" },
        },
        config = function()
            require("Comment").setup {}

            local ft = require("Comment.ft")
            ft.set("lean3", { "--%s", "/-%s-/" })
            ft.set("typst", { "//%s", "/*%s*/" })
        end,
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "BufReadPre",
        -- TODO: keys
        -- TODO: Surround with braces on new line?
        config = true,
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        -- TODO: Fix ``` in lua comments, disable `?
        -- TODO: Fix turbofish in rust
        config = function()
            require("nvim-autopairs").setup {}
            require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())

            table.insert(require("nvim-autopairs").get_rules("```")[1].filetypes, "typst")
        end,
    },
    {
        -- ALTERNATIVE: vim-wordmotion
        -- ALTERNATIVE: vim-textobj-variable-segment
        "bkad/CamelCaseMotion",
        event = "VeryLazy",
        init = function()
            vim.g.camelcasemotion_key = [[\]]
        end,
    },
    {
        -- ALTERNATIVE: Do this myself (see https://gist.github.com/habamax/0a6c1d2013ea68adcf2a52024468752e)
        "stsewd/gx-extended.vim",
        keys = { "gx" },
        init = function()
            vim.g["gxext#opencmd"] = "gx"
        end,
    },
}
