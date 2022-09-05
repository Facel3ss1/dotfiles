require("peter.set")
require("peter.packer")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local chezmoi_dir = vim.fn.expand("~") .. "/.local/share/chezmoi/"

autocmd("BufWritePost", {
    group = augroup("ChezmoiApplyOnSave", { clear = true }),
    pattern = chezmoi_dir .. "*",
    callback = function(opts)
        -- Ignore paths in the .git folder
        local path = opts.match
        local git_paths = vim.fn.glob(chezmoi_dir .. ".git/*", false, true)
        if vim.fn.index(git_paths, path) < 0 then 
            vim.cmd('!chezmoi apply --source-path "%"')
        end
    end
})

-- https://jeffkreeftmeijer.com/vim-number/#automatic-toggling-between-line-number-modes
local numbertoggle_group = augroup("NumberToggle", { clear = true })

autocmd({"BufEnter", "FocusGained", "InsertLeave", "WinEnter"}, {
    group = numbertoggle_group,
    pattern = "*",
    callback = function()
        if vim.o.number and vim.fn.mode() ~= "i" then
            vim.opt.relativenumber = true
        end
    end
})

autocmd({"BufLeave", "FocusLost", "InsertEnter", "WinLeave"}, {
    group = numbertoggle_group,
    pattern = "*",
    callback = function()
        if vim.o.number then
            vim.opt.relativenumber = false
        end
    end
})
