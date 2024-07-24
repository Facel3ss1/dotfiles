local icons = require("peter.util.icons")

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
    virtual_text = { spacing = 4, prefix = icons.ui.dot },
    severity_sort = true,
}

local signs = {
    Hint = icons.diagnostics.HINT,
    Info = icons.diagnostics.INFO,
    Warn = icons.diagnostics.WARN,
    Error = icons.diagnostics.ERROR,
}

-- FIXME: Use `signs` in vim.diagnostic.config in nvim 0.10
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    -- See :h diagnostic-signs
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
