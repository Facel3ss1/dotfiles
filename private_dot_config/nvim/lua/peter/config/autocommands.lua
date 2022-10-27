local augroup = require("peter.au").augroup
local autocmd

-- TODO: Add descriptions to autocommands

-- Load chezmoi config if we are in the chezmoi directory

autocmd = vim.api.nvim_create_autocmd
autocmd({ "BufReadPost", "BufNewFile" }, {
    pattern = "*/chezmoi/*",
    once = true,
    callback = function()
        require("peter.chezmoi")
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

autocmd = augroup("NumberToggle", { clear = true })
autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
    pattern = "*",
    callback = function()
        if vim.wo.number and vim.api.nvim_get_mode().mode ~= "i" then
            vim.wo.relativenumber = true
            enable_ts_context()
        end
    end,
})
autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
    pattern = "*",
    callback = function()
        if vim.wo.number then
            vim.wo.relativenumber = false
            enable_ts_context()
        end
    end,
})

-- Brief highlight when we yank something

autocmd = augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        pcall(vim.highlight.on_yank)
    end,
})

-- Only have cursorline on in the current window

local function set_cursorline(value)
    return function()
        vim.wo.cursorline = value
    end
end

autocmd = augroup("CursorLineToggle", { clear = true })
autocmd("WinEnter", { callback = set_cursorline(true) })
autocmd("WinLeave", { callback = set_cursorline(false) })
autocmd("FileType", { pattern = "TelescopePrompt", callback = set_cursorline(false) })

-- Disable/Change colorcolumn for certain filetypes
-- TODO: buftypes? filenames?

local function disable_colorcolumn()
    if vim.wo.colorcolumn ~= "80" then
        return
    end
    vim.wo.colorcolumn = ""
end

autocmd = augroup("SetColorColumn", { clear = true })
autocmd("FileType", {
    pattern = { "gitcommit", "NeogitCommitMessage" },
    callback = function()
        vim.wo.colorcolumn = "50,72"
    end,
})
autocmd("FileType", {
    pattern = {
        "help",
        "gitrebase",
        "qf",
        "checkhealth",
        "Neogit*",
        "packer",
        "tsplayground",
        "startuptime",
    },
    callback = disable_colorcolumn,
})
-- Each filetype will have it's own formatoptions which we need to override

autocmd = augroup("SetFormatOptions", { clear = true })
autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions
            - "o" -- o and O won't auto insert comments
            + "r" -- Insert comments when pressing enter
            + "j" -- Remove comment characters when joining
            + "q" -- Let me wrap comments with gq
    end,
})

autocmd = augroup("SetTerminalOptions", { clear = true })
autocmd("TermOpen", {
    callback = function()
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.wo.colorcolumn = ""
    end,
})
