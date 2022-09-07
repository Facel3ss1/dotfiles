local M = {}

M.bind = function(op, outer_opts)
    -- noremap by default, other default options can be specified in outer_opts
    outer_opts = vim.tbl_extend("force",
        {noremap = true},
        outer_opts or {}
    )

    return function(lhs, rhs, opts)
        opts = vim.tbl_extend("force",
            outer_opts,
            opts or {}
        )
        vim.keymap.set(op, lhs, rhs, opts)
    end
end

M.nmap = M.bind("n", {noremap = false})
M.imap = M.bind("i", {noremap = false})
M.nnoremap = M.bind("n")
M.vnoremap = M.bind("v")
M.xnoremap = M.bind("x")
M.inoremap = M.bind("i")

return M
