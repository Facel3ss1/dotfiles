local augroup = require("peter.au").augroup

local opt = vim.opt

opt.mouse = "a" -- Let me use the mouse for scrolling etc.

opt.relativenumber = true -- Show relative line numbers...
opt.number = true -- ...and show the current line number

-- Disables relativenumber for insert mode and inactive buffers
-- https://jeffkreeftmeijer.com/vim-number/#automatic-toggling-between-line-number-modes
augroup("NumberToggle", { clear = true }, {
    {{"BufEnter", "FocusGained", "InsertLeave", "WinLeave"},
    pattern = "*",
    callback = function()
        if vim.o.number and vim.fn.mode() ~= "i" then
            opt.relativenumber = true
        end
    end},
    {{"BufLeave", "FocusLost", "InsertEnter", "WinLeave"},
    pattern = "*",
    callback = function()
        if vim.o.number then
            opt.relativenumber = false
        end
    end},
})

opt.wrap = false -- Turn off line wrapping...
opt.breakindent = true -- ...but preserve indenting if we do wrap
opt.linebreak = true -- ...and break the line on certain characters if we wrap

opt.scrolloff = 10 -- There will be 10 lines above and below my cursor when scrolling
opt.sidescrolloff = 5 -- 5 columns to the side of my cursor when horizontally scrolling

opt.tabstop = 4 -- <Tab> characters will be displayed as 4 characters wide
opt.shiftwidth = 4 -- >, <, and = will work in increments of 4 characters
opt.softtabstop = 4 -- We want each indentation level to be 4 characters
opt.expandtab = true -- Use spaces instead of tabs for indentation

opt.autoindent = true -- Continue indentation from previous line
opt.smartindent = true -- Smartly add indentation when starting new line

opt.hlsearch = false -- Turn off highlighting of search results

opt.colorcolumn = "80" -- Put colored column at column 80
opt.cursorline = true -- Highlight current line cursor is on
opt.signcolumn = "yes" -- Always show the sign column

-- Only have it on in the current buffer
local function set_cursorline(value)
    return function()
        opt.cursorline = value
    end
end

augroup("CursorLineToggle", { clear = true }, {
    {"WinEnter", callback = set_cursorline(true)},
    {"WinLeave", callback = set_cursorline(false)},
    {"FileType", pattern = "TelescopePrompt", callback = set_cursorline(false)},
})

-- Split windows to the right and downwards
opt.splitright = true
opt.splitbelow = true

-- Each filetype will have it's own formatoptions which we need to override
augroup("SetFormatOptions", { clear = true }, {
    {"FileType", pattern = "*", callback = function()
        opt.formatoptions = opt.formatoptions
            - "o" -- o and O won't auto insert comments...
            + "r" -- ...but insert comments when pressing enter
            + "j" -- Remove comment characters when joining
            + "q" -- Let me wrap comments with gq
    end}
})
