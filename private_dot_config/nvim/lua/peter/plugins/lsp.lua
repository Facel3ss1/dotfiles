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
    ["pyright"] = {
        pyright = {
            -- We are using Ruff's import organizer instead
            disableOrganizeImports = true,
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

-- TODO: Use vim.g variables for these
local enable_format_on_save = true
local enable_typos_lsp_diagnostics = true

-- TODO: lsp_signature.nvim?

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
        dependencies = {
            "mason.nvim",
            { "williamboman/mason-lspconfig.nvim", version = "*" },
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            ---@param server_name string
            ---@return lspconfig.Config
            local function default_config(server_name)
                local capabilities = require("cmp_nvim_lsp").default_capabilities()

                ---@type lspconfig.Config
                local config = {
                    capabilities = capabilities,
                    settings = lsp_settings[server_name],
                }

                return config
            end

            require("mason-lspconfig").setup {
                -- TODO: jsonls
                ensure_installed = { "lua_ls" },
            }

            local lspconfig = require("lspconfig")
            require("mason-lspconfig").setup_handlers {
                -- Default handler
                function(server_name)
                    local config = default_config(server_name)
                    lspconfig[server_name].setup(config)
                end,
                ["typos_lsp"] = function(server_name)
                    local config = default_config(server_name)

                    --- typos_lsp uses init_options instead of settings for configuration
                    config.init_options = config.settings
                    config.settings = nil

                    config.on_attach = function(client, _buf)
                        -- TODO: Make the typos_lsp code actions do an LSP rename?

                        -- Set initial state of typos-lsp diagnostics
                        local typos_ns = vim.lsp.diagnostic.get_namespace(client.id)
                        vim.diagnostic.enable(enable_typos_lsp_diagnostics, { ns_id = typos_ns })
                    end

                    lspconfig[server_name].setup(config)
                end,
                -- rustaceanvim sets up rust-analyzer for us
                ["rust_analyzer"] = function() end,
                ["ts_ls"] = function(server_name)
                    local config = default_config(server_name)
                    config.on_attach = function(_client, buf)
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
                    end

                    require("typescript-tools").setup(config)
                end,
            }
        end,
    },
    -- FIXME: Remove, including note in README
    {
        "williamboman/mason.nvim",
        version = "*",
        cmd = { "Mason", "MasonInstall", "MasonUninstall" },
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
                width = 0.8,
                height = 0.8,
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
}
