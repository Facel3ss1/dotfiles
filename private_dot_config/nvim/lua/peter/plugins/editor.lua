return {
    { "tpope/vim-abolish", event = "VeryLazy" },
    {
        "echasnovski/mini.bracketed",
        version = false,
        event = "VeryLazy",
        opts = {
            -- Disable ]c and ]t keybinds, as they are used by gitsigns and todo-comments
            comment = { suffix = "" },
            treesitter = { suffix = "" },
        },
        config = function(_, opts)
            require("mini.bracketed").setup(opts)
        end,
    },
    {
        "folke/todo-comments.nvim",
        cmd = { "TodoQuickFix", "TodoLocList", "TodoTrouble", "TodoTelescope" },
        event = { "BufReadPost", "BufNewFile" },
        -- stylua: ignore
        keys = {
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment", },
            { "<leader>ft", "<Cmd>TodoTelescope keywords=TODO,FIXME,XXX<CR>", desc = "Find todos" },
        },
        opts = {
            signs = false,
            highlight = {
                keyword = "fg",
                after = "",
                -- This matches a todo with an author in brackets, as well as a todo on its own without a colon
                -- See https://github.com/folke/todo-comments.nvim/issues/10
                pattern = [=[.*<(KEYWORDS)(\([^\)]*\))?(:|$)]=],
            },
            search = {
                pattern = [=[\b(KEYWORDS)(\([^\)]*\))?(:|$)]=],
            },
            -- TODO: Configure the keywords
        },
        dependencies = "nvim-lua/plenary.nvim",
    },
}
