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
        "mrcjkb/rustaceanvim",
        version = "*",
        lazy = false, -- This plugin is already lazy
    },
}
