---@module "lazy"
---@type LazySpec
return {
    {
        "echasnovski/mini.bracketed",
        version = "*",
        event = "VeryLazy",
        opts = {
            -- Disable ]c and ]t keybinds, as they are used by mini.diff and todo-comments
            comment = { suffix = "" },
            treesitter = { suffix = "" },
        },
        config = function(_, opts)
            require("mini.bracketed").setup(opts)
        end,
    },
    -- TODO: Make this lazy
    -- TODO: Respect cwd in terminal buffers
    {
        "stevearc/oil.nvim",
        lazy = false, -- Load at startup so oil opens whenever nvim opens a directory
        cmd = { "Oil" },
        -- stylua: ignore
        keys = {
            { "-", function() require("oil").open() end, desc = "Open parent directory" },
        },
        opts = {
            view_options = {
                show_hidden = true,
            },
        },
        dependencies = { "nvim-tree/nvim-web-devicons" },
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
                -- FIXME: This GitHub issue has been closed
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
