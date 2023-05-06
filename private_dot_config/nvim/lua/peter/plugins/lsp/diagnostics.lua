local function format_error_code(diagnostic)
    if not diagnostic.code then
        return string.format(" %s", diagnostic.source)
    end

    return string.format(" %s(%s)", diagnostic.source, diagnostic.code)
end

vim.diagnostic.config {
    -- I don't want signs in the signcolumn
    signs = false,
    -- TODO: Colored border depending on severity?
    float = {
        suffix = format_error_code,
        border = "rounded",
    },
    -- TODO: Give higher priority than inlay hints
    virtual_text = { spacing = 4, prefix = "●" },
    severity_sort = true,
}

-- FIXME: Don't use deprecated symbols
local signs = { Error = "", Warn = "", Info = "", Hint = "" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    -- See :h diagnostic-signs
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
