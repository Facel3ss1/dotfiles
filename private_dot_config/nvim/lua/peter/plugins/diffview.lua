local M = {}

function M.setup()
    local nnoremap = require("peter.remap").nnoremap

    nnoremap("<leader>gd", "<Cmd>DiffviewOpen<CR>", {desc = "Open diff view"})
    nnoremap("<leader>gh", "<Cmd>DiffviewFileHistory<CR>", {desc = "Open history"})
    nnoremap("<leader>gH", "<Cmd>DiffviewFileHistory %<CR>", {desc = "Open file history"})
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
        }
    }
end

return M
