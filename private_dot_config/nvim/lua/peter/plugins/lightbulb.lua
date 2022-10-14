-- TODO: z index so lightbulb is behind diagnostics popups
require("nvim-lightbulb").setup {
    ignore = {"sumneko_lua"},
    sign = {
        enabled =  false,
    },
    float = {
        enabled = true,
        text = "",
    },
    autocmd = {
        enabled = true,
    },
}
