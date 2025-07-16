local icons = require("peter.util.icons")

---@module "lazy"
---@type LazySpec
return {
    {
        "kosayoda/nvim-lightbulb",
        event = { "LspAttach" },
        opts = {
            autocmd = {
                enabled = true,
            },
            sign = {
                text = icons.ui.lightbulb,
            },
        },
    },
}
