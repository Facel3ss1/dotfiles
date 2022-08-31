require("peter.set")
require("peter.packer")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

peter_group = augroup("peter", { clear = true })

autocmd("BufWritePost", {
    group = peter_group,
    -- This lua api doesn't expand the home directory by default
    pattern = vim.fn.expand("~") .. "/.local/share/chezmoi/*",
    command = '!chezmoi apply --source-path "%"',
})
