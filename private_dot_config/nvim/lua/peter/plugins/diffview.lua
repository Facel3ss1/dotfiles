local M = {}

function M.setup()
    local remap = require("peter.remap")
    local nnoremap = remap.nnoremap
    local xnoremap = remap.xnoremap

    nnoremap("<leader>gd", "<Cmd>DiffviewOpen<CR>", { desc = "Open diff view" })
    nnoremap("<leader>gh", "<Cmd>DiffviewFileHistory<CR>", { desc = "Open history" })
    nnoremap("<leader>gH", "<Cmd>DiffviewFileHistory %<CR>", { desc = "Open file history" })
    xnoremap("<leader>gH", ":DiffviewFileHistory %<CR>", { silent = true, desc = "Open history for range" })
end

function M.config()
    require("diffview").setup {
        enhanced_diff_hl = true,
        signs = {
            done = "",
        },
        keymaps = {
            file_panel = {
                ["q"] = "<Cmd>DiffviewClose<CR>",
            },
            file_history_panel = {
                ["q"] = "<Cmd>DiffviewClose<CR>",
            },
            view = {
                ["q"] = "<Cmd>DiffviewClose<CR>",
            },
        },
    }
end

return M
