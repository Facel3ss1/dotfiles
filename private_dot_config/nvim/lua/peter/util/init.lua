local M = {}

---Returns true if `feature` is supported.
---See `:h feature-list` and `:h has()`.
---@param feature string
---@return boolean
function M.has(feature)
    return vim.fn.has(feature) == 1
end

---Returns true if an executable called `name` exists.
---See `:h executable()`.
---@param name string
---@return boolean
function M.executable(name)
    return vim.fn.executable(name) == 1
end

---Displays a notification using the `INFO` log level.
---See `:h vim.notify()`.
---@param msg string
---@param opts table
function M.info(msg, opts)
    opts = opts or {}
    vim.notify(msg, vim.log.levels.INFO, opts)
end

---Displays a notification using the `WARN` log level.
---See `:h vim.notify()`.
---@param msg string
---@param opts table
function M.warn(msg, opts)
    opts = opts or {}
    vim.notify(msg, vim.log.levels.WARN, opts)
end

---Displays a notification using the `ERROR` log level.
---See `:h vim.notify()`.
---@param msg string
---@param opts table
function M.error(msg, opts)
    opts = opts or {}
    vim.notify(msg, vim.log.levels.ERROR, opts)
end

---Toggles the given vim boolean `option` locally, and displays a notification.
---@param option string
function M.toggle(option)
    vim.opt_local[option] = not vim.opt_local[option]:get()
    if vim.opt_local[option]:get() then
        M.info("Enabled " .. option, { title = "Option" })
    else
        M.info("Disabled " .. option, { title = "Option" })
    end
end

return M
