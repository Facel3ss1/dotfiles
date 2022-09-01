local highlight = require("peter.highlight")
local hl = highlight.hl
local fg_bg = highlight.fg_bg

require("gitsigns").setup {
    on_attach = function(bufnr)
        -- Fix gitsigns background
        hl("GitSignsAdd", fg_bg("GitSignsAdd", "SignColumn"))
        hl("GitSignsChange", fg_bg("GitSignsChange", "SignColumn"))
        hl("GitSignsDelete", fg_bg("GitSignsDelete", "SignColumn"))
    end
}
