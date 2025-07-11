-- Enable inlay hints by default
vim.lsp.inlay_hint.enable()

-- Buffer-local LSP config
local lsp_attach_group = vim.api.nvim_create_augroup("PeterLspAttach", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_attach_group,
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
            local codelens_group = vim.api.nvim_create_augroup("PeterLspCodelens", { clear = false })
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
    desc = "Apply buffer-local LSP config",
})
