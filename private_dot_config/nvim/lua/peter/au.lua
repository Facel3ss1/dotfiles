local M = {}

function M.augroup(name, opts, autocmds)
    local group_id = vim.api.nvim_create_augroup(name, opts)

    for _, autocmd in ipairs(autocmds or {}) do
        local autocmd_opts = vim.tbl_extend("force",
            autocmd,
            {group = group_id}
        )
        autocmd_opts[1] = nil

        vim.api.nvim_create_autocmd(autocmd[1], autocmd_opts)
    end

    return group_id
end

M.autocmd = vim.api.nvim_create_autocmd

return M
