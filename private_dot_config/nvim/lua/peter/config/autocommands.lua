-- Brief highlight when we yank something
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
    pattern = "*",
    callback = function()
        pcall(vim.highlight.on_yank)
    end,
    desc = "Call vim.highlight.on_yank()",
})

-- Only have cursorline on in the current window
local function set_cursorline(value)
    return function()
        vim.wo.cursorline = value
    end
end

local cursorline_group = vim.api.nvim_create_augroup("CursorLineToggle", { clear = true })
vim.api.nvim_create_autocmd("WinEnter", {
    group = cursorline_group,
    callback = set_cursorline(true),
    desc = "Enable cursorline",
})
vim.api.nvim_create_autocmd("WinLeave", {
    group = cursorline_group,
    callback = set_cursorline(false),
    desc = "Disable cursorline",
})
vim.api.nvim_create_autocmd("FileType", {
    group = cursorline_group,
    pattern = "TelescopePrompt",
    callback = set_cursorline(false),
    desc = "Disable cursorline",
})

-- Resize splits if the window got resized
vim.api.nvim_create_autocmd("VimResized", {
    group = vim.api.nvim_create_augroup("ResizeSplits", { clear = true }),
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
    desc = "Run :tabdo wincmd =",
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("CommitMessageColorColumn", { clear = true }),
    pattern = { "gitcommit", "jj" },
    callback = function()
        vim.wo.colorcolumn = "50,72"
    end,
    desc = "Set colorcolumn = 50,72",
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("EnableWrap", { clear = true }),
    pattern = { "markdown", "typst" },
    callback = function()
        vim.wo.wrap = true
    end,
    desc = "Set wrap = true",
})

-- TODO: Quit certain filetypes when I press q

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("SetCommentString", { clear = true }),
    pattern = "gitconfig",
    callback = function()
        vim.bo.commentstring = "# %s"
    end,
    desc = 'Set commentstring = "# %s"',
})

-- TODO: Should we just set a default formatoptions?
-- Each filetype will have it's own formatoptions which we need to override
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("SetFormatOptions", { clear = true }),
    pattern = "*",
    callback = function()
        vim.opt.formatoptions = vim.opt.formatoptions
            - "o" -- o and O won't auto insert comments
            + "r" -- Insert comments when pressing enter
            + "j" -- Remove comment characters when joining
            + "q" -- Let me wrap comments with gq
    end,
    desc = "Change formatoptions: +rjq -o",
})

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("HelpConcealLevel", { clear = true }),
    pattern = "help",
    callback = function()
        vim.wo.conceallevel = 0
    end,
    desc = "Set conceallevel = 0",
})

vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("SetTerminalOptions", { clear = true }),
    callback = function()
        vim.wo.number = false
        vim.wo.relativenumber = false
    end,
    desc = "Disable line numbers",
})
