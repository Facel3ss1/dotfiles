-- Add a rounded border to docs hovers
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = "rounded"})

-- Always jump to the first definition when we go to definition
vim.lsp.handlers["textDocument/definition"] = function(_, result)
    if not result or vim.tbl_isempty(result) then
        vim.notify("[LSP] No results from textDocument/definition", vim.log.levels.INFO, {title = "LSP"})
        return
    end

    if vim.tbl_islist(result) then
        result = result[1]
    end

    vim.lsp.util.jump_to_location(result, "utf-8", false)
end
