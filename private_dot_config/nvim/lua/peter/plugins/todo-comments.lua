---@module "lazy"
---@type LazySpec
return {
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoQuickFix", "TodoLocList", "TodoTelescope" },
        event = { "BufReadPost", "BufNewFile" },
        -- stylua: ignore
        keys = {
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment", },
            { "<leader>ft", "<Cmd>TodoTelescope keywords=TODO,FIXME,XXX<CR>", desc = "Find todos" },
        },
        opts = {
            signs = false,
            -- The search and highlight patterns allow for an optional author in brackets e.g. KEYWORD(author)
            search = {
                pattern = [[\b(KEYWORDS)(\([^\)]*\))?:]],
            },
            highlight = {
                keyword = "fg",
                after = "",
                pattern = [[.*<((KEYWORDS)%(\(.{-1,}\))?):]],
            },
        },
        dependencies = "nvim-lua/plenary.nvim",
    },
}
