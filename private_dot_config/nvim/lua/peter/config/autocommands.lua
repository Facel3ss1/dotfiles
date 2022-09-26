local augroup = require("peter.au").augroup
local autocmd

-- Run chezmoi apply when we save our config

-- TODO: Move chezmoi path to an env.lua file or something
-- FIXME: Check for chezmoi using vim.fn.executable
-- FIXME: Use chezmoi template to fill this in?
local chezmoi_dir = vim.fn.expand("~") .. "/.local/share/chezmoi/"

autocmd = augroup("ChezmoiApplyOnSave", {clear = true})
autocmd("BufWritePost", {
    pattern = chezmoi_dir .. "*",
    callback = function(opts)
        -- FIXME: Use filetype detection instead?
        -- FIXME: Discarding in Neogit?

        -- Ignore paths in the .git folder
        local path = opts.match
        local git_paths = vim.fn.glob(chezmoi_dir .. ".git/*", false, true)
        if vim.fn.index(git_paths, path) < 0 then 
            vim.cmd('!chezmoi apply --source-path "%"')
        end
    end,
})

-- Disables relativenumber for insert mode and inactive buffers.
-- https://jeffkreeftmeijer.com/vim-number/#automatic-toggling-between-line-number-modes

-- Enable nvim-treesitter-context using pcall (it may not be loaded)
-- Enabling it causes its line numbers to redraw
local function enable_ts_context()
    local _, ts_context = pcall(require, "treesitter-context")
    pcall(ts_context.enable)
end

autocmd = augroup("NumberToggle", {clear = true})
autocmd({"BufEnter", "FocusGained", "InsertLeave", "WinEnter"}, {
    pattern = "*",
    callback = function()
        if vim.o.number and vim.api.nvim_get_mode().mode ~= "i" then
            vim.opt.relativenumber = true
            enable_ts_context()
        end
    end,
})
autocmd({"BufLeave", "FocusLost", "InsertEnter", "WinLeave"}, {
    pattern = "*",
    callback = function()
        if vim.o.number then
            vim.opt.relativenumber = false
            enable_ts_context()
        end
    end,
})

-- Brief highlight when we yank something

autocmd = augroup("YankHighlight", {clear = true})
autocmd("TextYankPost", {
    pattern = "*", callback = function() vim.highlight.on_yank() end,
})

-- Only have cursorline on in the current window

local function set_cursorline(value)
    return function()
        vim.opt.cursorline = value
    end
end

autocmd = augroup("CursorLineToggle", {clear = true})
autocmd("WinEnter", {callback = set_cursorline(true)})
autocmd("WinLeave", {callback = set_cursorline(false)})
autocmd("FileType", {pattern = "TelescopePrompt", callback = set_cursorline(false)})

-- Each filetype will have it's own formatoptions which we need to override

autocmd = augroup("SetFormatOptions", {clear = true})
autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions
            + "o" -- o and O will auto insert comments
            + "r" -- Insert comments when pressing enter
            + "j" -- Remove comment characters when joining
            + "q" -- Let me wrap comments with gq
    end,
})
