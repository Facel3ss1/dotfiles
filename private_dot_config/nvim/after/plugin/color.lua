vim.opt.termguicolors = true
vim.g.ayucolor = "mirage"
vim.cmd("colorscheme ayu")

local function hl(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- Remove background
hl("Normal", {
    bg = "none",
    ctermbg = "none",
})

-- Change to comment color
-- hl("LineNr", {
--     link = "Comment",
-- })

hl("SignColumn", {
    link = "Normal",
})
