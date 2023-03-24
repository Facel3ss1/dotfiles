return {
    -- TODO: glow.nvim
    { "tpope/vim-sleuth", cmd = "Sleuth", event = "BufReadPre" },
    -- ALTERNATIVE: mini.bracketed
    { "tpope/vim-unimpaired", event = "VeryLazy" },
    { "dstein64/vim-startuptime", cmd = "StartupTime" },
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

                    local map = function(lhs, rhs, map_opts)
                        map_opts.buffer = args.buf
                        vim.keymap.set("n", lhs, rhs, map_opts)
                    end
                    map("<leader>ccp", crates.show_crate_popup, { desc = "Show crate popup" })
                    map("<leader>ccv", crates.show_versions_popup, { desc = "Show crate versions" })
                    map("<leader>ccf", crates.show_features_popup, { desc = "Show crate features" })
                    map("<leader>ccd", crates.show_dependencies_popup, { desc = "Show crate dependencies" })
                end,
                desc = "Register crates.nvim keybindings",
            })

            crates.setup(opts)
        end,
        dependencies = "nvim-lua/plenary.nvim",
    },
}
