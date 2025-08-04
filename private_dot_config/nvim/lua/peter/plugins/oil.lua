---@module "lazy"
---@type LazySpec
return {
    {
        "stevearc/oil.nvim",
        version = "*",
        lazy = false, -- Load at startup so oil opens whenever nvim opens a directory
        cmd = { "Oil" },
        -- stylua: ignore
        keys = {
            { "-", function() require("oil").open() end, desc = "Open parent directory" },
        },
        ---@module "oil"
        ---@type oil.SetupOpts
        opts = {
            view_options = {
                show_hidden = true,
            },
            keymaps = {
                -- These keymaps conflicted with smart-splits.nvim
                ["<C-h>"] = false, -- Use <C-s> to horizontal split instead
                ["<C-l>"] = false, -- Use `:e` to refresh instead

                ["<C-s>"] = { "actions.select", opts = { horizontal = true } },
                ["<C-v>"] = { "actions.select", opts = { vertical = true } },
            },
        },
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
}
