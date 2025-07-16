---@module "lazy"
---@type LazySpec
return {
    {
        "mrjones2014/smart-splits.nvim",
        version = "*",
        lazy = false, -- It is recommended to not lazy load this plugin
        -- stylua: ignore
        keys = {
            { "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move cursor to left window" },
            { "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Move cursor to down window" },
            { "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move cursor to up window" },
            { "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move cursor to right window" },

            { "<A-h>", function() require("smart-splits").resize_left() end, desc = "Resize window left" },
            { "<A-j>", function() require("smart-splits").resize_down() end, desc = "Resize window down" },
            { "<A-k>", function() require("smart-splits").resize_up() end, desc = "Resize window up" },
            { "<A-l>", function() require("smart-splits").resize_right() end, desc = "Resize window right" },

            { "<leader>wh", function() require("smart-splits").swap_buf_left() end, desc = "Swap window left" },
            { "<leader>wj", function() require("smart-splits").swap_buf_down() end, desc = "Swap window down" },
            { "<leader>wk", function() require("smart-splits").swap_buf_up() end, desc = "Swap window up" },
            { "<leader>wl", function() require("smart-splits").swap_buf_right() end, desc = "Swap window right" },
        },
        opts = {
            at_edge = "stop",
        },
    },
}
