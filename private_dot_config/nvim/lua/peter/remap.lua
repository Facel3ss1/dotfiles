local M = {}

-- Returns a wrapper around `vim.keymap.set` which will set keymaps for the
-- given modes (`op`) using the defaults specified in `default_opts`.
--
-- ```lua
-- local remap = require("peter.remap")
--
-- function on_attach(bufnr)
--     local nvnoremap = remap.bind({"n", "v"}, {buffer = bufnr})
--     -- Creates a buffer local non-recursive mapping in normal and visual mode
--     nvnoremap("<leader>w", "<Cmd>write<CR>", {desc = "Save file"})
-- end
-- ```
--- @param op string|string[] # The mode(s) the keymap will be defined for.
--- @param default_opts? table<string, any> # Defaults for the keymaps. Note that unless overidden, noremap = true
--- @return fun(lhs: string, rhs: string|function, opts?: table<string, any>) remap # The mapping function
--- @nodiscard
function M.bind(op, default_opts)
    default_opts = vim.tbl_extend("force", { noremap = true }, default_opts or {})

    return function(lhs, rhs, opts)
        opts = vim.tbl_extend("force", default_opts, opts or {})

        vim.keymap.set(op, lhs, rhs, opts)
    end
end

M.nnoremap = M.bind("n")
M.xnoremap = M.bind("x")
M.inoremap = M.bind("i")
M.snoremap = M.bind("s")

return M
