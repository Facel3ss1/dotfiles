-- TODO: Quit certain filetypes when I press q

-- Enable soft word wrapping by default in Markdown and Typst files
-- This only changes how text is displayed, not the contents of the file
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("peter.enable_wrap", { clear = true }),
    pattern = { "markdown", "typst" },
    callback = function()
        -- Using opt_local means that the wrapping won't persist if we switch the window to a different buffer
        vim.opt_local.wrap = true
    end,
    desc = "Set wrap = true",
})

-- Add two coloured columns at 50 and 72 characters when writing commit messages
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("peter.set_colorcolumn", { clear = true }),
    pattern = { "gitcommit", "jj" },
    callback = function()
        vim.opt_local.colorcolumn = "50,72"
    end,
    desc = "Set colorcolumn = 50,72",
})

-- Add a comment string to git config files so I can comment things out
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("peter.set_commentstring", { clear = true }),
    pattern = "gitconfig",
    callback = function()
        vim.bo.commentstring = "# %s"
    end,
    desc = 'Set commentstring = "# %s"',
})

-- Let me use K in man pages
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("peter.set_keywordprg", { clear = true }),
    pattern = "man",
    callback = function()
        vim.bo.keywordprg = ":Man"
    end,
    desc = 'Set keywordprg = ":Man"',
})

-- Enable cfilter plugin for quickfix list (See `:h cfilter-plugin`)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    group = vim.api.nvim_create_augroup("peter.packadd_cfilter", { clear = true }),
    callback = function()
        -- `:h pack-add` says we need a bang, but this doesn't load the plugin,
        -- it only adds the files to 'runtimepath' - given that lazy.nvim is
        -- managing the runtimepath lets just add it normally.
        vim.cmd.packadd { "cfilter" }
    end,
    desc = "Run :packadd cfilter",
})
