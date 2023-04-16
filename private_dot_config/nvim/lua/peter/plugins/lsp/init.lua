return {
    -- TODO: lsp_signature.nvim?
    -- TODO: inlay-hints.nvim
    {
        "neovim/nvim-lspconfig",
        -- FIXME: Make it work when I :e myfile
        event = "BufReadPre",
        cmd = { "LspInfo" },
        dependencies = {
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
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
        init = function()
            require("peter.plugins.lsp.diagnostics")
        end,
        config = function()
            -- Add a rounded border to docs hovers
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

            -- TODO: Keybind to see all the definitions?
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
                map("n", "gK", vim.lsp.buf.signature_help, { desc = "View signature help" })
                -- TODO: Add floating border to this
                map("i", "<C-k>", vim.lsp.buf.signature_help, { desc = "View signature help" })
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
                ["lua_ls"] = {
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
                -- TODO: jsonls
                ensure_installed = { "lua_ls" },
            }
            require("mason-lspconfig").setup_handlers {
                default_handler,
                ["lua_ls"] = function(server_name)
                    require("neodev").setup {
                        -- TODO: Use neoconf instead?
                        -- TODO: Enable in .nvim.lua files?
                        override = function(root_dir, library)
                            -- Add vim plugins and api to path if we are in the chezmoi config directory
                            local config_dir = require("peter.config.chezmoi").source_dir .. "/private_dot_config/nvim"
                            if root_dir == config_dir then
                                library.enabled = true
                                library.plugins = true
                            end
                        end,
                    }

                    default_handler(server_name)
                end,
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
                                ---@diagnostic disable-next-line: assign-type-mismatch
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
        keys = {
            { "<leader>um", "<Cmd>Mason<CR>", desc = "Open Mason" },
        },
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

            -- Mason package name -> null-ls source
            local mason_sources = {
                stylua = null_ls.builtins.formatting.stylua,
                isort = null_ls.builtins.formatting.isort,
                black = null_ls.builtins.formatting.black,
                flake8 = null_ls.builtins.diagnostics.flake8,
            }

            local sources = {
                null_ls.builtins.formatting.fish_indent,
                null_ls.builtins.diagnostics.fish,
            }

            -- Only enable null-ls sources if the mason package is installed
            local mason_registry = require("mason-registry")
            for package_name, source in pairs(mason_sources) do
                local package = mason_registry.get_package(package_name)
                if package:is_installed() then
                    table.insert(sources, source)
                end
            end

            return {
                sources = sources,
            }
        end,
        dependencies = { "mason.nvim", "nvim-lua/plenary.nvim" },
    },
    { "folke/neodev.nvim" },
    { "simrat39/rust-tools.nvim", dependencies = "nvim-lua/plenary.nvim" },
    { url = "https://git.sr.ht/~p00f/clangd_extensions.nvim" },
    {
        "mrcjkb/haskell-tools.nvim",
        version = "1.*",
        dependencies = { "nvim-lua/plenary.nvim", "telescope.nvim" },
    },
}
