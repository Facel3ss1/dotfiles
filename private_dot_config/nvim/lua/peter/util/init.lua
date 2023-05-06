local M = {}

function M.has(feature)
    return vim.fn.has(feature) == 1
end

function M.executable(name)
    return vim.fn.executable(name) == 1
end

function M.info(msg, opts)
    opts = opts or {}
    vim.notify(msg, vim.log.levels.INFO, opts)
end

function M.warn(msg, opts)
    opts = opts or {}
    vim.notify(msg, vim.log.levels.WARN, opts)
end

function M.toggle(option)
    vim.opt_local[option] = not vim.opt_local[option]:get()
    if vim.opt_local[option]:get() then
        M.info("Enabled " .. option, { title = "Option" })
    else
        M.info("Disabled " .. option, { title = "Option" })
    end
end

local diagnostics_enabled = true
function M.toggle_diagnostics()
    diagnostics_enabled = not diagnostics_enabled

    if diagnostics_enabled then
        vim.diagnostic.enable()
        M.info("Enabled diagnostics", { title = "Diagnostics" })
    else
        vim.diagnostic.disable()
        M.info("Disabled diagnostics", { title = "Diagnostics" })
    end
end

return M
