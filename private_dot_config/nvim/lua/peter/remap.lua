local M = {}

--- Returns a function which lets you define keymaps for the specified mode(s)
--- with the specified options.
--- @param op string|table The mode(s) the keymap will be defined for.
--- @param outer_opts? table The options that will be applied for the keymaps. By default noremap = true
--- @return fun(lhs: string, rhs: string|function, opts?: table|string) # The mapping function
--- @nodiscard
function M.bind(op, outer_opts)
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

M.nnoremap = M.bind("n")
M.xnoremap = M.bind("x")
M.inoremap = M.bind("i")
M.snoremap = M.bind("s")

return M
