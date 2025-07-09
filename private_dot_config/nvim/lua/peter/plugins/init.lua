local util = require("peter.util")

-- TODO: glow.nvim

---@module "lazy"
---@type LazySpec
return {
    {
        "saecki/crates.nvim",
        version = "*",
        event = { "BufRead Cargo.toml" },
        opts = {
            lsp = {
                enabled = true,
                actions = true,
                completion = true,
                hover = true,
            },
        },
    },
    {
        "linux-cultist/venv-selector.nvim",
        branch = "regexp",
        ft = "python",
        cmd = { "VenvSelect" },
        keys = {
            { "<leader>cv", "<Cmd>VenvSelect<CR>", desc = "Select virtualenv", ft = "python" },
        },
        opts = {
            settings = {
                options = {
                    notify_user_on_venv_activation = true,
                },
            },
        },
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-telescope/telescope.nvim",
            -- TODO
            -- "mfussenegger/nvim-dap",
            -- "mfussenegger/nvim-dap-python",
        },
    },
    {
        "chomosuke/typst-preview.nvim",
        version = "*",
        ft = "typst",
        cmd = {
            "TypstPreview",
            "TypstPreviewFollowCursorToggle",
            "TypstPreviewSyncCursor",
        },
        opts = {
            -- Skip download of tinymist by the plugin, it must be installed manually
            -- websocat will be automatically downloaded by the plugin
            dependencies_bin = {
                ["tinymist"] = "tinymist",
                ["websocat"] = nil,
            },
        },
        config = true,
        cond = util.executable("tinymist"),
    },
    {
        "tpope/vim-abolish",
        cmd = { "Abolish", "Subvert", "S" },
    },
}
