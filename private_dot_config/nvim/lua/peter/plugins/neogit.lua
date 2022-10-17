local M = {}

-- TODO: Disable colorcolumn for neogit windows (except commits)

function M.setup()
    local nnoremap = require("peter.remap").nnoremap

    nnoremap("<leader>gs", "<Cmd>Neogit<CR>", { desc = "Open Neogit status" })
    nnoremap("<leader>gc", "<Cmd>Neogit commit<CR>", { desc = "Commit" })
end

function M.config()
    require("neogit").setup {
        disable_builtin_notifications = true,
        signs = {
            section = { "", "" },
            item = { "", "" },
        },
        integrations = {
            diffview = true,
        },
    }
end

return M
