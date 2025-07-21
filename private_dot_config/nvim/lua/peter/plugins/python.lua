---@module "lazy"
---@type LazySpec
return {
    {
        "linux-cultist/venv-selector.nvim",
        branch = "regexp",
        ft = "python",
        cmd = { "VenvSelect" },
        opts = {
            options = {
                notify_user_on_venv_activation = true,
            },
        },
        dependencies = {
            "neovim/nvim-lspconfig",
            -- TODO
            -- "mfussenegger/nvim-dap",
            -- "mfussenegger/nvim-dap-python",
        },
    },
}
