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
    -- TODO: typst.nvim or treesitter parser? They were both WIP when I added this
    {
        "kaarmu/typst.vim",
        ft = "typst",
        lazy = false,
    },
}
