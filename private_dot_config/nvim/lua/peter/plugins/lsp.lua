local util = require("peter.util")
local icons = require("peter.util.icons")

-- TODO: Use vim.g variables for these
local enable_format_on_save = true
local enable_typos_lsp_diagnostics = true

---@module "lazy"
---@type LazySpec
return {
    {
        -- FIXME: Migrate to vim.lsp.config in 0.11
        "neovim/nvim-lspconfig",
        version = "*",
        -- FIXME: Make it work when I :e myfile
        event = "BufReadPre",
        cmd = { "LspInfo", "LspLog" },
        keys = {
            {
                "<leader>ts",
                function()
                    enable_typos_lsp_diagnostics = not enable_typos_lsp_diagnostics

                    if enable_typos_lsp_diagnostics then
                        util.info("Enabled spell checking", { title = "typos" })
                    else
                        util.info("Disabled spell checking", { title = "typos" })
                    end

                    local clients = vim.lsp.get_clients { name = "typos_lsp" }
                    if #clients ~= 1 then
                        return
                    end

                    local typos_client = clients[1]
                    local typos_ns = vim.lsp.diagnostic.get_namespace(typos_client.id)

                    vim.diagnostic.enable(enable_typos_lsp_diagnostics, { ns_id = typos_ns })
                end,
                desc = "Toggle typos spell checking",
                mode = { "n" },
            },
        },
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            lspconfig.lua_ls.setup {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace",
                            postfix = ".",
                        },
                        diagnostics = {
                            libraryFiles = "Disable",
                            unusedLocalExclude = { "_*" },
                            groupSeverity = {
                                ["unused"] = "Warning",
                            },
                        },
                        format = {
                            enable = false,
                        },
                        hint = {
                            enable = true,
                            arrayIndex = "Disable",
                            setType = true,
                        },
                        workspace = {
                            checkThirdParty = false,
                        },
                    },
                },
            }

            lspconfig.typos_lsp.setup {
                capabilities = capabilities,
                -- typos-lsp uses `init_options` instead of `settings` for configuration
                init_options = {
                    diagnosticSeverity = "Hint",
                },
                -- Set initial state of typos-lsp diagnostics
                on_attach = function(client, _buf)
                    -- TODO: Make the typos_lsp code actions do an LSP rename?
                    local typos_ns = vim.lsp.diagnostic.get_namespace(client.id)
                    vim.diagnostic.enable(enable_typos_lsp_diagnostics, { ns_id = typos_ns })
                end,
            }

            lspconfig.basedpyright.setup {
                capabilities = capabilities,
                settings = {
                    basedpyright = {
                        -- We are using Ruff's import organizer instead
                        disableOrganizeImports = true,
                    },
                },
            }

            lspconfig.ruff.setup {
                capabilities = capabilities,
            }

            -- rust_analyzer is configured using the rustaceanvim plugin below

            -- tsserver is configured using the typescript-tools plugin below
            -- Note that tsserver is included already within a typescript installation and is not the same thing as typescript-language-server
        end,
    },
    {
        "stevearc/conform.nvim",
        version = "*",
        event = "BufWritePre",
        cmd = "ConformInfo",
        keys = {
            {
                "<leader>cf",
                function()
                    require("conform").format()
                end,
                desc = "Format document",
                mode = { "n" },
            },
            {
                "<leader>cf",
                function()
                    require("conform").format()
                end,
                desc = "Format range",
                mode = { "v" },
            },
            {
                "<leader>tf",
                function()
                    enable_format_on_save = not enable_format_on_save

                    if enable_format_on_save then
                        util.info("Enabled format on save", { title = "Formatting" })
                    else
                        util.info("Disabled format on save", { title = "Formatting" })
                    end
                end,
                desc = "Toggle format on save",
                mode = { "n" },
            },
        },
        ---@type conform.setupOpts
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                javascript = { "prettierd", "prettier", stop_after_first = true },
                javascriptreact = { "prettierd", "prettier", stop_after_first = true },
                typescript = { "prettierd", "prettier", stop_after_first = true },
                typescriptreact = { "prettierd", "prettier", stop_after_first = true },
                python = { "ruff_format", "ruff_organize_imports" },
            },
            format_on_save = function(_buf)
                if not enable_format_on_save then
                    return
                end

                return {
                    timeout_ms = 500,
                    lsp_format = "fallback",
                }
            end,
        },
    },
    -- TODO: Replace with mini.notify?
    {
        "j-hui/fidget.nvim",
        event = { "LspAttach" },
        version = "*",
        opts = {
            progress = {
                display = {
                    done_icon = icons.ui.done,
                },
            },
            notification = {
                window = {
                    winblend = 0,
                },
            },
        },
    },
    {
        "kosayoda/nvim-lightbulb",
        event = { "LspAttach" },
        opts = {
            autocmd = {
                enabled = true,
            },
            sign = {
                text = icons.ui.lightbulb,
            },
        },
    },
    -- FIXME: The nvim-cmp source for require() module names doesn't seem to work
    {
        "folke/lazydev.nvim",
        version = "*",
        ft = { "lua" },
        opts = {
            library = {
                { path = "luvit-meta/library", words = { "vim%.uv" } },
                { path = "wezterm-types", mods = { "wezterm" } },
            },
        },
    },
    { "Bilal2453/luvit-meta" },
    { "justinsgithub/wezterm-types" },
    {
        "mrcjkb/rustaceanvim",
        version = "*",
        lazy = false, -- This plugin is already lazy
        opts = {
            server = {
                settings = {
                    ["rust-analyzer"] = {
                        check = {
                            command = "clippy",
                            extraArgs = { "--no-deps" },
                        },
                    },
                },
            },
        },
        config = function(_, opts)
            vim.g.rustaceanvim = vim.tbl_deep_extend("force", {}, opts or {})
        end,
    },
    {
        "pmizio/typescript-tools.nvim",
        ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        opts = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            return {
                capabilities = capabilities,
                on_attach = function(_client, buf)
                    vim.keymap.set(
                        "n",
                        "gs",
                        "<Cmd>TSToolsGoToSourceDefinition<CR>",
                        { buffer = buf, desc = "Go to source definition" }
                    )

                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = vim.api.nvim_create_augroup("OrganizeImportsOnSave", { clear = true }),
                        command = "TSToolsOrganizeImports",
                        desc = "Organize typescript imports",
                    })
                end,
            }
        end,
        config = true,
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    },
}
