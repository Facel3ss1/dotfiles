return {
    -- TODO: glow.nvim
    { "dstein64/vim-startuptime", cmd = "StartupTime" },
    {
        "saecki/crates.nvim",
        version = "*",
        event = { "BufRead Cargo.toml" },
        opts = {
            on_attach = function(bufnr)
                require("cmp").setup.buffer { sources = { { name = "crates" } } }

                vim.keymap.set("n", "K", function()
                    require("crates").show_popup()
                end, { desc = "Show crate popup", buffer = bufnr })
            end,
        },
    },
    -- TODO: typst.nvim or treesitter parser? They were both WIP when I added this
    {
        "kaarmu/typst.vim",
        ft = "typst",
        lazy = false,
    },
}
