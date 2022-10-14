local nnoremap = require("peter.remap").nnoremap

vim.diagnostic.config {
    -- I don't want signs in the signcolumn
    signs = false,
    -- TODO: Colored border depending on severity
    float = { border = "rounded" },
    -- TODO: Colored background for virtual text?
    virtual_text = { spacing = 4, prefix = "●" },
    severity_sort = true,
}

-- Navigation between diagnostics prioritises errors first, then warnings etc.

local severity_levels = {
    vim.diagnostic.severity.ERROR,
    vim.diagnostic.severity.WARN,
    vim.diagnostic.severity.INFO,
    vim.diagnostic.severity.HINT,
}

local function get_highest_diag_severity()
    for _, level in ipairs(severity_levels) do
        local diags = vim.diagnostic.get(0, { severity = { min = level } })
        if #diags > 0 then
            return level
        end
    end
end

-- TODO: Replace these with ]e and use ]d for regular diag next/prev
nnoremap("]d", function()
    vim.diagnostic.goto_next({severity = get_highest_diag_severity()})
end, { desc = "Next diagnostic" })

nnoremap("[d", function()
    vim.diagnostic.goto_prev({severity = get_highest_diag_severity()})
end, { desc = "Previous diagnostic" })

nnoremap("<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- Define diagnostic signs
local signs = { Error = "", Warn = "", Info = "", Hint = "" }

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
