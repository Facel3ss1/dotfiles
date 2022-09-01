local highlight = require("peter.highlight")
local hl = highlight.hl
local fg_bg = highlight.fg_bg

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

-- Fix diff colors
hl("DiffDelete", fg_bg("WarningMsg", "DiffAdd"))

hl("diffAdded", {
    link = "DiffAdd"
})

hl("diffChanged", {
    link = "DiffChange"
})

hl("diffRemoved", {
    link = "DiffDelete"
})
