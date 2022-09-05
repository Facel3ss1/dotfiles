require("ayu").setup {
    mirage = true,
    overrides = {
        Normal = { bg = "none" },
        SignColumn = { bg = "none" },
    },
}

require("ayu").colorscheme()
