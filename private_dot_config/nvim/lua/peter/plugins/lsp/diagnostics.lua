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

local signs = { Error = "", Warn = "", Info = "", Hint = "" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    -- See :h diagnostic-signs
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Navigation between "problems" prioritises errors first, then warnings etc.

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

vim.keymap.set("n", "]e", function()
    vim.diagnostic.goto_next { severity = get_highest_diag_severity() }
end, { desc = "Next problem" })

vim.keymap.set("n", "[e", function()
    vim.diagnostic.goto_prev { severity = get_highest_diag_severity() }
end, { desc = "Previous problem" })

vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })

vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

local diagnostics_enabled = true
local function toggle_diagnostics()
    diagnostics_enabled = not diagnostics_enabled

    if diagnostics_enabled then
        vim.diagnostic.enable()
        vim.notify("Enabled diagnostics", vim.log.levels.INFO, { title = "Diagnostics" })
    else
        vim.diagnostic.disable()
        vim.notify("Disabled diagnostics", vim.log.levels.INFO, { title = "Diagnostics" })
    end
end
vim.keymap.set("n", "<leader>td", toggle_diagnostics, { desc = "Toggle diagnostics" })
