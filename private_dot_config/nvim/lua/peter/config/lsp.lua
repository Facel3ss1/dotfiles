local lib = require("peter.lib")

-- Enable inlay hints by default
vim.lsp.inlay_hint.enable()

-- Buffer-local LSP settings
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("peter.lsp.attach", { clear = true }),
    callback = function(args)
        ---@type integer
        local buf = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id) --[[@as vim.lsp.Client]]

        -- stylua: ignore start
        -- Neovim has these default mappings for K and <C-s> (See `:h lsp-defaults`), but I want to add a rounded border to their windows
        -- FIXME: Remove these when I set `:h 'winborder'` to rounded
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover { border = "rounded" } end, { buffer = buf, desc = "Hover documentation" })
        vim.keymap.set({ "i", "s" }, "<C-s>", function() vim.lsp.buf.signature_help { border = "rounded" } end, { buffer = buf, desc = "View signature help" })
        -- stylua: ignore end

        -- Remove the K keymap in help files so I can use K to go to help tags instead (See `:h lsp-defaults-disable`)
        if vim.bo[buf].filetype == "help" then
            vim.keymap.del("n", "K", { buffer = buf })
        end

        -- Use internal formatting instead of `vim.lsp.formatexpr()` so that gq rewraps text instead of LSP formatting
        -- See `:h lsp-defaults`
        vim.bo[buf].formatexpr = nil

        -- Show codelenses and refresh them intermittently
        if client.server_capabilities.codeLensProvider then
            local codelens_group = vim.api.nvim_create_augroup("peter.lsp.codelens", { clear = false })
            if #vim.api.nvim_get_autocmds { group = codelens_group, buffer = buf } == 0 then
                vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                    group = codelens_group,
                    buffer = buf,
                    callback = function()
                        vim.lsp.codelens.refresh { bufnr = buf }
                    end,
                    desc = "Call vim.lsp.codelens.refresh()",
                })
            end
        end

        -- Use LSP folding if client supports it (See `:h vim.lsp.foldexpr()`)
        if client:supports_method("textDocument/foldingRange") then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
        end
    end,
    desc = "Apply buffer-local LSP settings",
})

-- See `:h lsp-quickstart`, these configs are intended to build upon the configs in https://github.com/neovim/nvim-lspconfig

vim.lsp.config("lua_ls", {
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
})

-- Allow toggling typos-lsp diagnostics with keybind
vim.keymap.set("n", "<leader>ts", function()
    local clients = vim.lsp.get_clients { name = "typos_lsp" }
    if #clients ~= 1 then
        lib.error("typos-lsp is not active", { name = "typos" })
        return
    end

    local typos_client = clients[1]
    local typos_ns = vim.lsp.diagnostic.get_namespace(typos_client.id)
    local diagnostics_enabled = vim.diagnostic.is_enabled { ns_id = typos_ns }
    diagnostics_enabled = not diagnostics_enabled

    if diagnostics_enabled then
        lib.info("Enabled spell checking", { title = "typos" })
    else
        lib.info("Disabled spell checking", { title = "typos" })
    end

    vim.diagnostic.enable(diagnostics_enabled, { ns_id = typos_ns })
end, { desc = "Toggle typos spell checking" })

vim.lsp.config("typos_lsp", {
    -- typos-lsp uses `init_options` instead of `settings` for configuration
    init_options = {
        diagnosticSeverity = "Hint",
    },
})

-- The "rust-analyzer" name is used by rustaceanvim, which is what we want, whereas the "rust_analyzer" name is used by nvim-lspconfig
vim.lsp.config("rust-analyzer", {
    settings = {
        ["rust-analyzer"] = {
            check = {
                command = "clippy",
                extraArgs = { "--no-deps" },
            },
        },
    },
})

vim.lsp.config("basedpyright", {
    settings = {
        basedpyright = {
            -- We are using Ruff's import organizer instead
            disableOrganizeImports = true,
        },
    },
})

-- rust-analyzer is enabled by the rustaceanvim plugin

-- tsserver is configured and enabled by the typescript-tools plugin
-- Note that tsserver is included already within a typescript installation and is not the same thing as typescript-language-server (AKA ts_ls)

-- LSPs can also be configured and enabled using project-local configuration (See `:h 'exrc'`)

vim.lsp.enable { "lua_ls", "typos_lsp", "basedpyright", "ruff" }
