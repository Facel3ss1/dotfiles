-- Change leader to space
-- This is the first thing we do so that mappings from now on are set correctly
vim.g.mapleader = " "

require("peter.globals")
require("peter.config.options")
require("peter.config.keymap")
require("peter.config.plugins")

local augroup = require("peter.au").augroup

-- FIXME: Check for chezmoi using vim.fn.executable
-- FIXME: Use template to fill this in?
local chezmoi_dir = vim.fn.expand("~") .. "/.local/share/chezmoi/"

augroup("ChezmoiApplyOnSave", { clear = true }, {
    {"BufWritePost", pattern = chezmoi_dir .. "*", callback = function(opts)
        -- FIXME: Use filetype detection instead
        -- FIXME: Discarding in Neogit?
        -- Ignore paths in the .git folder
        local path = opts.match
        local git_paths = vim.fn.glob(chezmoi_dir .. ".git/*", false, true)
        if vim.fn.index(git_paths, path) < 0 then 
            vim.cmd('!chezmoi apply --source-path "%"')
        end
    end},
})
