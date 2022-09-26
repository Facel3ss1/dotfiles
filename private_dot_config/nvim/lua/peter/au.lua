local M = {}

--- @alias PeterAutocmd fun(event: string|string[], autocmd_opts?: table<string, any>): any

-- Wrapper around `vim.api.nvim_create_augroup` that returns a wrapper around
-- `vim.api.nvim_create_autocmd` with its `group` option set.
--
-- ```lua
-- local augroup = require("peter.au")
--
-- local autocmd = augroup("YankHighlight", {clear = true})
-- autocmd("TextYankPost", {
--     pattern = "*", callback = function() vim.highlight.on_yank() end,
-- })
-- ```
--- @param name string # The name of the group
--- @param augroup_opts? table<string, any> # Dictionary parameters for the autogroup
--- @return PeterAutocmd autocmd # The autocommand function
--- @return any group_id # The integer ID of the created group
function M.augroup(name, augroup_opts)
    local group_id = vim.api.nvim_create_augroup(name, augroup_opts)

    --- @type PeterAutocmd
    local function autocmd(event, autocmd_opts)
        autocmd_opts = vim.tbl_extend("force",
            autocmd_opts or {},
            {group = group_id}
        )

        return vim.api.nvim_create_autocmd(event, autocmd_opts)
    end

    return autocmd, group_id
end

M.autocmd = vim.api.nvim_create_autocmd

return M
