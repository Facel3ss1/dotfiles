-- Show a brief highlight when I yank something
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("peter.yank_highlight", { clear = true }),
    pattern = "*",
    callback = function()
        pcall(vim.hl.on_yank)
    end,
    desc = "Call vim.hl.on_yank()",
})

-- Only enable the cursorline in the current window

local function set_cursorline_callback(value)
    return function()
        vim.wo.cursorline = value
    end
end

local cursorline_group = vim.api.nvim_create_augroup("peter.cursorline_toggle", { clear = true })
vim.api.nvim_create_autocmd("WinEnter", {
    group = cursorline_group,
    callback = set_cursorline_callback(true),
    desc = "Enable cursorline",
})
vim.api.nvim_create_autocmd("WinLeave", {
    group = cursorline_group,
    callback = set_cursorline_callback(false),
    desc = "Disable cursorline",
})
vim.api.nvim_create_autocmd("FileType", {
    group = cursorline_group,
    pattern = "TelescopePrompt",
    callback = set_cursorline_callback(false),
    desc = "Disable cursorline",
})

-- Resize splits if the overall window got resized
vim.api.nvim_create_autocmd("VimResized", {
    group = vim.api.nvim_create_augroup("peter.resize_splits", { clear = true }),
    callback = function()
        vim.cmd("tabdo wincmd =")
    end,
    desc = "Run :tabdo wincmd =",
})

-- Modify the formatoptions for every filetype
-- TODO: Should we just set a default formatoptions?
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("peter.change_format_options", { clear = true }),
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
