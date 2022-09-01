local hl = require("peter.highlight").hl

vim.opt.termguicolors = true
vim.g.ayucolor = "mirage"
vim.cmd("colorscheme ayu")

-- Remove background
hl("Normal", {
    bg = "none",
})

-- Change to comment color
-- hl("LineNr", {
--     link = "Comment",
-- })
