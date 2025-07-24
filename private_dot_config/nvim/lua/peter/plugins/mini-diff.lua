local icons = require("peter.lib.icons")

---@module "lazy"
---@type LazySpec
return {
    {
        "echasnovski/mini.diff",
        version = "*",
        event = "BufReadPre",
        keys = {
            {
                "<leader>gp",
                function()
                    require("mini.diff").toggle_overlay(0)
                end,
                desc = "Preview changes",
            },
        },
        opts = {
            view = {
                style = "sign",
                signs = {
                    add = icons.git.added_sign,
                    change = icons.git.modified_sign,
                    delete = icons.git.deleted_sign,
                },
            },
            mappings = {
                goto_prev = "[c",
                goto_next = "]c",
                goto_first = "[C",
                goto_last = "]C",
            },
        },
    },
}
