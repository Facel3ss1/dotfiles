local util = require("peter.util")
local icons = require("peter.util.icons")

local lsp_settings = {
    ["lua_ls"] = {
        Lua = {
            completion = {
                callSnippet = "Replace",
                postfix = ".",
            },
            diagnostics = {
                libraryFiles = "Disable",
                unusedLocalExclude = { "_*" },
            },
            format = {
                enable = false,
            },
            workspace = {
                checkThirdParty = false,
            },
        },
    },
    ["rust_analyzer"] = {
        ["rust-analyzer"] = {
            check = {
                command = "clippy",
                extraArgs = { "--no-deps" },
            },
        },
    },
    ["typos_lsp"] = {
        diagnosticSeverity = "Hint",
    },
}

local enable_format_on_save = true
local enable_typos_lsp_diagnostics = true

-- TODO: lsp_signature.nvim?

---@module "lazy"
---@type LazySpec
return {
    {
        "neovim/nvim-lspconfig",
        -- FIXME: Make it work when I :e myfile
        event = "BufReadPre",
        cmd = { "LspInfo" },
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
        dependencies = {
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            -- Add a rounded border to docs hovers
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

            -- TODO: Keybind to see all the definitions?
            -- Always jump to the first definition when we go to definition
            vim.lsp.handlers["textDocument/definition"] = function(_, result)
                if not result or vim.tbl_isempty(result) then
                    util.info("[LSP] No results from textDocument/definition", { title = "LSP" })
                    return
                end

                if vim.islist(result) then
                    result = result[1]
                end

                vim.lsp.util.jump_to_location(result, "utf-8", false)
            end

            -- Enable inlay hints by default
            vim.lsp.inlay_hint.enable()

            local function on_attach(args)
                local buf = args.buf
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client == nil then
                    util.error("[LSP] Could not find client with id " .. args.data.client_id, { title = "LSP" })
                    return
                end

                ---@param mode string|string[]
                ---@param lhs string
                ---@param rhs string|function
                ---@param opts vim.keymap.set.Opts?
                local function map(mode, lhs, rhs, opts)
                    opts.buffer = buf
                    vim.keymap.set(mode, lhs, rhs, opts)
                end

                -- TODO: Add floating border to this
                -- map("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "View signature help" })
                map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
                map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
                map("n", "go", "<Cmd>Telescope lsp_type_definitions<CR>", { desc = "Go to type definition" })
                map("n", "gI", "<Cmd>Telescop lsp_implementations<CR>", { desc = "Go to implementations" })
                map("n", "gr", "<Cmd>Telescope lsp_references<CR>", { desc = "Go to references" })

                map("n", "<leader>fs", "<Cmd>Telescope lsp_document_symbols<CR>", { desc = "Find document symbol" })
                map("n", "<leader>fS", "<Cmd>Telescope lsp_workspace_symbols<CR>", { desc = "Find workspace symbol" })

                map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
                map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
                map("n", "<leader>cl", vim.lsp.codelens.run, { desc = "Run code lens" })

                map("n", "<leader>th", function()
                    local inlay_hints_enabled = vim.lsp.inlay_hint.is_enabled()
                    inlay_hints_enabled = not inlay_hints_enabled

                    vim.lsp.inlay_hint.enable(inlay_hints_enabled)

                    if inlay_hints_enabled then
                        util.info("Enabled inlay hints", { title = "Inlay hints" })
                    else
                        util.info("Disabled inlay hints", { title = "Inlay hints" })
                    end
                end, { desc = "Toggle inlay hints" })

                -- Use internal formatting instead of `vim.lsp.formatexpr()` so that gq works
                -- See https://github.com/neovim/neovim/pull/19677
                vim.bo[buf].formatexpr = nil

                if client.server_capabilities.codeLensProvider then
                    local codelens_group = vim.api.nvim_create_augroup("PeterLspCodelens", { clear = false })
                    if #vim.api.nvim_get_autocmds { group = codelens_group, buffer = args.buf } == 0 then
                        vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                            group = codelens_group,
                            buffer = args.buf,
                            callback = function()
                                vim.lsp.codelens.refresh()
                            end,
                            desc = "Call vim.lsp.codelens.refresh()",
                        })
                    end
                end

                -- Set initial state of typos-lsp diagnostics
                if client.name == "typos_lsp" then
                    local typos_ns = vim.lsp.diagnostic.get_namespace(client.id)
                    vim.diagnostic.enable(enable_typos_lsp_diagnostics, { ns_id = typos_ns })
                end
            end

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("PeterLspAttach", { clear = true }),
                callback = on_attach,
                desc = "Call LSP on_attach()",
            })

            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local function default_handler(server_name)
                require("lspconfig")[server_name].setup {
                    capabilities = capabilities,
                    settings = lsp_settings[server_name],
                }
            end

            require("mason-lspconfig").setup {
                -- TODO: jsonls
                ensure_installed = { "lua_ls" },
            }
            require("mason-lspconfig").setup_handlers {
                default_handler,
                ["typos_lsp"] = function(server_name)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities,
                        init_options = lsp_settings[server_name],
                    }
                end,
                -- rustaceanvim sets up rust-analyzer for us
                ["rust_analyzer"] = function() end,
                ["tsserver"] = function(server_name)
                    require("typescript-tools").setup {
                        capabilities = capabilities,
                        settings = lsp_settings[server_name],
                        on_attach = function(_, buf)
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
                -- haskell-tools sets up hls for us
                ["hls"] = function() end,
                ["clangd"] = function(server_name)
                    require("clangd_extensions").setup {
                        server = {
                            capabilities = capabilities,
                            settings = lsp_settings[server_name],
                            on_attach = function(_, buf)
                                vim.keymap.set(
                                    "n",
                                    "<leader>ch",
                                    "<Cmd>ClangdSwitchSourceHeader<CR>",
                                    { buffer = buf, desc = "Switch between source/header" }
                                )
                            end,
                        },
                    }

                    local cmp = require("cmp")

                    -- FIXME: clangd completion entries have a space/bullet before
                    cmp.setup.filetype({ "c", "cpp" }, {
                        sorting = {
                            comparators = {
                                cmp.config.compare.offset,
                                cmp.config.compare.exact,
                                cmp.config.compare.recently_used,
                                require("clangd_extensions.cmp_scores"),
                                cmp.config.compare.kind,
                                cmp.config.compare.sort_text,
                                cmp.config.compare.length,
                                cmp.config.compare.order,
                            },
                            priority_weight = 1,
                        },
                    })
                end,
            }
        end,
    },
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        keys = {
            { "<leader>um", "<Cmd>Mason<CR>", desc = "Open Mason" },
        },
        -- TODO: Automatically update installed packages
        opts = {
            ui = {
                border = "rounded",
                icons = {
                    package_installed = icons.packages.installed,
                    package_pending = icons.packages.pending,
                    package_uninstalled = icons.packages.uninstalled,
                },
            },
        },
        config = function(_, opts)
            require("mason").setup(opts)

            local ensure_installed = {
                "stylua",
                "typos-lsp",
            }
            local mason_registry = require("mason-registry")
            for _, package_name in ipairs(ensure_installed) do
                local package = mason_registry.get_package(package_name)
                if not package:is_installed() then
                    package:install()
                end
            end
        end,
    },
    {
        "stevearc/conform.nvim",
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
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                javascript = { { "prettierd", "prettier" } },
                javascriptreact = { { "prettierd", "prettier" } },
                typescript = { { "prettierd", "prettier" } },
                typescriptreact = { { "prettierd", "prettier" } },
                -- TODO: Use ruff for formatting
                python = { "isort", "black" },
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
            },
        },
    },
    { "Bilal2453/luvit-meta" },
    {
        "mrcjkb/rustaceanvim",
        version = "*",
        ft = { "rust" },
        opts = {
            server = {
                settings = lsp_settings["rust_analyzer"],
            },
        },
        config = function(_, opts)
            vim.g.rustaceanvim = vim.tbl_deep_extend("force", {}, opts or {})
        end,
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    },
    { url = "https://git.sr.ht/~p00f/clangd_extensions.nvim" },
    {
        "mrcjkb/haskell-tools.nvim",
        version = "*",
        ft = { "haskell", "lhaskell", "cabal", "cabalproject " },
        config = function(_, opts)
            vim.g.haskell_tools = vim.tbl_deep_extend("force", {}, opts or {})
        end,
    },
}
