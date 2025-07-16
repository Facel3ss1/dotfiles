---@module "lazy"
---@type LazySpec
return {
    {
        "Saghen/blink.cmp",
        version = "*",
        event = { "InsertEnter", "CmdlineEnter" },
        ---@module "blink.cmp"
        ---@type blink.cmp.Config
        opts = {
            -- See `:h ins-completion`
            keymap = { preset = "default" },
            completion = {
                documentation = { auto_show = true },
                menu = {
                    draw = { treesitter = { "lsp" } },
                },
            },
            sources = {
                per_filetype = {
                    lua = { inherit_defaults = true, "lazydev" },
                },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100, -- Show at higher priority than lsp source
                    },
                },
            },
        },
        config = true,
    },
}
