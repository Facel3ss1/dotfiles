---@module "lazy"
---@type LazySpec
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
                    ["<C-n>"] = cmp.mapping(function()
                        if cmp.visible() then
                            cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
                        else
                            cmp.complete()
                        end
                    end),
                    ["<C-p>"] = cmp.mapping(function()
                        if cmp.visible() then
                            cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
                        else
                            cmp.complete()
                        end
                    end),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<C-y>"] = cmp.mapping.confirm { select = true },
                },
                sources = cmp.config.sources {
                    { name = "nvim_lsp" },
                    { name = "path" },
                    { name = "buffer" },
                },
                snippet = {
                    expand = function(args)
                        vim.snippet.expand(args.body)
                    end,
                },
                formatting = {
                    format = require("lspkind").cmp_format {
                        mode = "symbol_text",
                        menu = {
                            buffer = "[buf]",
                            nvim_lsp = "[lsp]",
                            path = "[path]",
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
            "hrsh7th/cmp-cmdline",
            "dmitmel/cmp-cmdline-history",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
        },
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
}
