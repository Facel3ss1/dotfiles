return {
    {
        "saecki/crates.nvim",
        version = "0.3.0",
        event = "BufRead Cargo.toml",
        opts = {
            null_ls = {
                enabled = true,
                name = "crates.nvim",
            },
        },
        config = function(_, opts)
            local crates = require("crates")

            vim.api.nvim_create_autocmd("BufRead", {
                group = vim.api.nvim_create_augroup("CargoCrates", { clear = true }),
                pattern = "Cargo.toml",
                callback = function(args)
                    require("cmp").setup.buffer { sources = { { name = "crates" } } }

                    require("which-key").register({ c = { name = "crates" } }, { prefix = "<leader>c" })

                    local map = function(lhs, rhs, opts)
                        opts.buffer = args.buf
                        vim.keymap.set("n", lhs, rhs, opts)
                    end
                    map("<leader>ccp", crates.show_crate_popup, { desc = "Show crate popup" })
                    map("<leader>ccv", crates.show_versions_popup, { desc = "Show crate versions" })
                    map("<leader>ccf", crates.show_features_popup, { desc = "Show crate features" })
                    map("<leader>ccd", crates.show_dependencies_popup, { desc = "Show crate dependencies" })
                end,
            })

            crates.setup(opts)
        end,
        dependencies = "nvim-lua/plenary.nvim",
    },
}
