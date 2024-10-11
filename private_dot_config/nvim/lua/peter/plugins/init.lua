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
}
