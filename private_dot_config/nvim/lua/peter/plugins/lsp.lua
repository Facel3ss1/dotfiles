local util = require("peter.util")
local icons = require("peter.util.icons")

-- TODO: Use vim.g variable for this
local enable_format_on_save = true

---@module "lazy"
---@type LazySpec
return {
    {
        "neovim/nvim-lspconfig",
        version = "*",
        event = "BufReadPre",
        cmd = { "LspRestart", "LspLog" },
        dependencies = { "hrsh7th/cmp-nvim-lsp" },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            vim.lsp.config("*", {
                capabilities = capabilities,
            })
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
                        "grs",
                        "<Cmd>TSToolsGoToSourceDefinition<CR>",
                        { buffer = buf, desc = "Go to source definition" }
                    )

                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = vim.api.nvim_create_augroup("peter.organize_ts_imports_on_save", { clear = true }),
                        command = "TSToolsOrganizeImports",
                        desc = "Organize TypeScript imports",
                    })
                end,
            }
        end,
        config = true,
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    },
}
