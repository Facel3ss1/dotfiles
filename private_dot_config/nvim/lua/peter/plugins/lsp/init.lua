return {
    -- TODO: lsp_signature.nvim?
    -- TODO: hl-args with lua exlude self and use and/or nvim-semantic-tokens
    {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        dependencies = {
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            {
                "folke/neodev.nvim",
                opts = {
                    -- TODO: Use neoconf instead?
                    override = function(root_dir, options)
                        -- Add vim plugins and api to path if we are in the chezmoi directory
                        local chezmoi_dir = require("peter.chezmoi").source_dir
                        if require("neodev.util").has_file(chezmoi_dir, root_dir) then
                            options.enabled = true
                            options.plugins = true
                        end
                    end,
                },
            },
            {
                "j-hui/fidget.nvim",
                opts = {
                    text = {
                        spinner = "dots",
                        done = "",
                    },
                    timer = {
                        spinner_rate = 75,
                    },
                },
            },
            {
                "kosayoda/nvim-lightbulb",
                opts = {
                    autocmd = {
                        enabled = true,
                    },
                },
                config = function(_, opts)
                    require("nvim-lightbulb").setup(opts)
                    vim.fn.sign_define("LightBulbSign", { text = "", texthl = "LightBulbSign" })
                end,
            },
        },
        config = function()
            require("peter.plugins.lsp.diagnostics")

            -- Add a rounded border to docs hovers
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

            -- Always jump to the first definition when we go to definition
            vim.lsp.handlers["textDocument/definition"] = function(_, result)
                if not result or vim.tbl_isempty(result) then
                    vim.notify("[LSP] No results from textDocument/definition", vim.log.levels.INFO, { title = "LSP" })
                    return
                end

                if vim.tbl_islist(result) then
                    result = result[1]
                end

                vim.lsp.util.jump_to_location(result, "utf-8", false)
            end

            local function on_attach(args)
                local buf = args.buf
                local client = vim.lsp.get_client_by_id(args.data.client_id)

                local function map(mode, lhs, rhs, opts)
                    opts.buffer = buf
                    vim.keymap.set(mode, lhs, rhs, opts)
                end

                map("n", "K", vim.lsp.buf.hover, { desc = "View docs under cursor" })
                map("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "View signature help" })
                map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
                map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
                map("n", "go", "<Cmd>Telescope lsp_type_definitions<CR>", { desc = "Go to type definition" })
                map("n", "gI", "<Cmd>Telescop lsp_implementations<CR>", { desc = "Go to implementations" })
                map("n", "gr", "<Cmd>Telescope lsp_references<CR>", { desc = "Go to references" })

                map("n", "<leader>fs", "<Cmd>Telescope lsp_document_symbols<CR>", { desc = "Find document symbol" })
                map("n", "<leader>fS", "<Cmd>Telescope lsp_workspace_symbols<CR>", { desc = "Find workspace symbol" })

                map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
                map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
                map("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format document" })
                map("v", "<leader>cf", vim.lsp.buf.format, { desc = "Format range" })
                map("n", "<leader>cl", vim.lsp.codelens.run, { desc = "Run code lens" })

                require("peter.plugins.lsp.format").on_attach(client, buf)

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
            end

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("PeterLspAttach", { clear = true }),
                callback = on_attach,
                desc = "Call LSP on_attach()",
            })

            local settings = {
                ["sumneko_lua"] = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace",
                            postfix = ".",
                        },
                        diagnostics = {
                            libraryFiles = "Disable",
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
                        checkOnSave = {
                            command = "clippy",
                            extraArgs = { "--no-deps" },
                        },
                    },
                },
            }

            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local function default_handler(server_name)
                require("lspconfig")[server_name].setup {
                    capabilities = capabilities,
                    settings = settings[server_name],
                }
            end

            require("mason-lspconfig").setup {
                ensure_installed = { "sumneko_lua" },
            }
            require("mason-lspconfig").setup_handlers {
                default_handler,
                ["rust_analyzer"] = function(server_name)
                    require("rust-tools").setup {
                        server = {
                            capabilities = capabilities,
                            settings = settings[server_name],
                        },
                    }
                end,
                ["hls"] = function(server_name)
                    require("haskell-tools").setup {
                        hls = {
                            capabilities = capabilities,
                            settings = settings[server_name],
                        },
                    }
                end,
                ["clangd"] = function(server_name)
                    require("clangd_extensions").setup {
                        server = {
                            capabilities = capabilities,
                            settings = settings[server_name],
                        },
                    }

                    local cmp = require("cmp")

                    -- FIXME: clangd completion entries have a space before
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
                        },
                    })
                end,
            }
        end,
    },
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        -- TODO: Automatically update installed packages
        opts = {
            ui = {
                border = "rounded",
                icons = {
                    package_installed = "",
                    package_pending = "",
                    package_uninstalled = "●",
                },
            },
        },
        config = function(_, opts)
            require("mason").setup(opts)

            local ensure_installed = {
                "stylua",
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
        "jose-elias-alvarez/null-ls.nvim",
        event = "BufReadPre",
        opts = function()
            local null_ls = require("null-ls")

            return {
                sources = {
                    null_ls.builtins.formatting.fish_indent,
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.diagnostics.fish,
                },
            }
        end,
        dependencies = { "mason.nvim", "nvim-lua/plenary.nvim" },
    },
    { "simrat39/rust-tools.nvim", dependencies = "nvim-lua/plenary.nvim" },
    { url = "https://git.sr.ht/~p00f/clangd_extensions.nvim" },
    {
        "mrcjkb/haskell-tools.nvim",
        version = "1.*",
        dependencies = { "nvim-lua/plenary.nvim", "telescope.nvim" },
    },
}
