local ok, nvim_tree = pcall(require, "nvim-tree")
if not ok then
    return
end

local nt_api = require("nvim-tree.api")
local nnoremap = require("peter.keymap").nnoremap

-- TODO: Refresh nvim-tree on neogit status update

-- nnoremap("<leader>nt", nt_api.tree.focus)
nnoremap("<leader>nt", function() nt_api.tree.toggle(false, false) end, {desc = "Toggle file tree"})

nvim_tree.setup {
    hijack_cursor = true,
    sort_by = "extension",
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
    filters = {
        custom = {"^\\.git$"},
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
            git_placement = "after",
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
