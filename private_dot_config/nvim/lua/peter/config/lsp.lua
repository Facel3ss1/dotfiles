local util = require("peter.util")

-- Add a rounded border to docs hovers
local hover_handler = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/hover"] = hover_handler

-- FIXME: Use on_list handler and vim.lsp.util.show_document in nvim 0.11
-- TODO: Keybind to see all the definitions? e.g. 1gd?
-- Always jump to the first definition when we go to definition
local function definition_handler(_, result)
    if not result or vim.tbl_isempty(result) then
        util.info("[LSP] No results from textDocument/definition", { title = "LSP" })
        return
    end

    if vim.islist(result) then
        result = result[1]
    end

    vim.lsp.util.jump_to_location(result, "utf-8", false)
end
vim.lsp.handlers["textDocument/definition"] = definition_handler

-- Enable inlay hints by default
vim.lsp.inlay_hint.enable()

-- Buffer-local LSP config
local lsp_attach_group = vim.api.nvim_create_augroup("PeterLspAttach", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_attach_group,
    callback = function(args)
        ---@type integer
        local buf = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
            util.error("[LSP] Could not find client with id " .. args.data.client_id, { title = "LSP" })
            return
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
    end,
    desc = "Apply buffer-local LSP config",
})
