-- Disables relativenumber for insert mode and inactive buffers.
-- https://jeffkreeftmeijer.com/vim-number/#automatic-toggling-between-line-number-modes

-- Enable nvim-treesitter-context using pcall (it may not be loaded)
local function redraw_treesitter_context()
    local _, ts_context = pcall(require, "treesitter-context")
    -- Redraw treesitter-context's line number
    pcall(ts_context.enable)
end

local numbertoggle_group = vim.api.nvim_create_augroup("NumberToggle", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
    group = numbertoggle_group,
    pattern = "*",
    callback = function()
        if vim.wo.number and vim.api.nvim_get_mode().mode ~= "i" then
            vim.wo.relativenumber = true
            redraw_treesitter_context()
        end
    end,
    desc = "Enable relativenumber",
})
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
    group = numbertoggle_group,
    pattern = "*",
    callback = function()
        if vim.wo.number then
            vim.wo.relativenumber = false
            redraw_treesitter_context()
        end
    end,
    desc = "Disable relativenumber",
})

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

-- FIXME: If we change these options then change the *window* (not buffer) to
-- one where these options don't apply, we should revert the changes

-- Disable/Change colorcolumn for certain filetypes
-- TODO: buftypes? filenames?
-- TODO: Set based on textwidth option

local function disable_colorcolumn()
    if vim.wo.colorcolumn ~= "80" then
        return
    end
    vim.wo.colorcolumn = ""
end

local colorcolumn_group = vim.api.nvim_create_augroup("SetColorColumn", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = colorcolumn_group,
    pattern = { "gitcommit", "NeogitCommitMessage" },
    callback = function()
        vim.wo.colorcolumn = "50,72"
    end,
    desc = "Set colorcolumn = 50,72",
})
vim.api.nvim_create_autocmd("FileType", {
    group = colorcolumn_group,
    pattern = {
        "help",
        "gitrebase",
        "qf",
        "checkhealth",
        "Neogit*",
        "startuptime",
    },
    callback = disable_colorcolumn,
    desc = "Disable colorcolumn",
})

-- TODO: Quit certain filetypes when I press q

-- TODO: Move to filetype plugin?
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

vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("SetTerminalOptions", { clear = true }),
    callback = function()
        vim.wo.number = false
        vim.wo.relativenumber = false
        vim.wo.colorcolumn = ""
    end,
    desc = "Disable line numbers and colorcolumn",
})

vim.filetype.add {
    filename = {
        [".clang-format"] = "yaml",
        [".clang-tidy"] = "yaml",
    },
}
