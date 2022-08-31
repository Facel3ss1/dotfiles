local nt_api = require("nvim-tree.api")
local nnoremap = require("peter.keymap").nnoremap

-- nnoremap("<leader>nt", nt_api.tree.focus)
nnoremap("<leader>nt", function() nt_api.tree.toggle(false, false) end)

require("nvim-tree").setup {
    hijack_cursor = true,
    sort_by = "extension",
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
    renderer = {
        group_empty = true,
        indent_markers = {
            enable = true,
            icons = {
                corner = "│",
            },
        },
        icons = {
            show = {
                folder_arrow = false,
            },
        },
    },
    view = {
        -- FIXME: This will get deprecated
        mappings = {
            list = {
                { key = {"l", "<CR>", "<2-LeftMouse>"}, action = "edit" },
                { key = "h", action = "close_node" },
            },
        },
    },
}
