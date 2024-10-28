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
        keys = {
            { "<leader>cp", "<Cmd>TypstPreview<CR>", desc = "Open typst preview", ft = "typst" },
        },
        opts = function()
            -- We want to use the mason tinymist binary
            local tinymist_package = require("mason-registry").get_package("tinymist")
            local tinymist_path = vim.fs.normalize(tinymist_package:get_install_path())
                .. "/"
                .. require("typst-preview.fetch").get_tinymist_bin_name()

            return {
                dependencies_bin = {
                    ["tinymist"] = tinymist_path,
                },
            }
        end,
        config = true,
        build = function()
            -- This will install the websocat binary, but not tinymist, since we specified the tinymist mason binary above
            require("typst-preview").update()
        end,
    },
}
