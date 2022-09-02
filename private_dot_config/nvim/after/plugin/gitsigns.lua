local keymap = require("peter.keymap")

require("gitsigns").setup {
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local nnoremap = keymap.bind("n", {buffer = bufnr})
        local vnoremap = keymap.bind("v", {buffer = bufnr})

        nnoremap("]c", function()
            if vim.wo.diff then return "]c" end
            vim.schedule(function() gs.next_hunk() end)
            return "<Ignore>"
        end, {expr = true})

        nnoremap("[c", function()
            if vim.wo.diff then return "[c" end
            vim.schedule(function() gs.prev_hunk() end)
            return "<Ignore>"
        end, {expr = true})

        nnoremap("<leader>hs", ":Gitsigns stage_hunk<CR>")
        vnoremap("<leader>hs", ":Gitsigns stage_hunk<CR>")
        nnoremap("<leader>hr", ":Gitsigns reset_hunk<CR>")
        vnoremap("<leader>hr", ":Gitsigns reset_hunk<CR>")

        nnoremap("<leader>hu", gs.undo_stage_hunk)
        nnoremap("<leader>hp", gs.preview_hunk)
    end
}
