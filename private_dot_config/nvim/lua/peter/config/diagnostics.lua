local icons = require("peter.util.icons")

local icon_mapping = {
    [vim.diagnostic.severity.ERROR] = icons.diagnostics.ERROR,
    [vim.diagnostic.severity.WARN] = icons.diagnostics.WARN,
    [vim.diagnostic.severity.INFO] = icons.diagnostics.INFO,
    [vim.diagnostic.severity.HINT] = icons.diagnostics.HINT,
}

local function icon_prefix(diagnostic)
    return icon_mapping[diagnostic.severity] .. " "
end

local function error_code_suffix(diagnostic)
    if not diagnostic.code then
        return string.format(" %s", diagnostic.source)
    end

    return string.format(" %s(%s)", diagnostic.source, diagnostic.code)
end

vim.diagnostic.config {
    signs = {
        -- I don't want signs in the signcolumn
        severity = {},
        text = icon_mapping,
    },
    -- TODO: Colored border depending on severity?
    float = {
        border = "rounded",
        suffix = error_code_suffix,
    },
    virtual_text = {
        spacing = 4,
        prefix = icon_prefix,
    },
    severity_sort = true,
}
