local M = {}

---Returns true if `feature` is supported by Neovim.
---See `:h feature-list` and `:h has()`.
---@param feature string
---@return boolean
function M.has_feature(feature)
    return vim.fn.has(feature) == 1
end

---Returns true if `name` is an executable file in Neovim's PATH.
---See `:h executable()` and `:h vim.env`.
---@param name string
---@return boolean
function M.is_executable(name)
    return vim.fn.executable(name) == 1
end

---Displays a notification using the `INFO` log level.
---See `:h vim.notify()`.
---@param msg string
---@param opts table
function M.info(msg, opts)
    vim.notify(msg, vim.log.levels.INFO, opts or {})
end

---Displays a notification using the `WARN` log level.
---See `:h vim.notify()`.
---@param msg string
---@param opts table
function M.warn(msg, opts)
    vim.notify(msg, vim.log.levels.WARN, opts or {})
end

---Displays a notification using the `ERROR` log level.
---See `:h vim.notify()`.
---@param msg string
---@param opts table
function M.error(msg, opts)
    vim.notify(msg, vim.log.levels.ERROR, opts or {})
end

---Toggles the given vim boolean `option` locally, and displays a notification.
---See `:h vim.opt_local`
---@param option string
function M.toggle_option(option)
    vim.opt_local[option] = not vim.opt_local[option]:get()
    if vim.opt_local[option]:get() then
        M.info(string.format("Enabled '%s'", option), { title = "Option" })
    else
        M.info(string.format("Disabled '%s'", option), { title = "Option" })
    end
end

return M
