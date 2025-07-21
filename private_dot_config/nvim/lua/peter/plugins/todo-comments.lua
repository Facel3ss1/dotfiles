---@module "lazy"
---@type LazySpec
return {
    {
        "folke/todo-comments.nvim",
        event = { "BufReadPost", "BufNewFile" },
        -- stylua: ignore
        keys = {
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment", },
        },
        opts = {
            signs = false,
            -- Note that we don't use the search feature as I have made my own fzf-lua picker for that
            highlight = {
                keyword = "fg",
                after = "",
                -- The highlight pattern allows for an optional author in brackets e.g. KEYWORD(author)
                -- See https://github.com/folke/todo-comments.nvim/issues/10
                pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
            },
        },
        dependencies = "nvim-lua/plenary.nvim",
    },
}
