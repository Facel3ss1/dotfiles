-- TODO: Quit certain filetypes when I press q

-- Enable soft word wrapping in Markdown and Typst files
-- This only changes how text is displayed, not the contents of the file
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("EnableWrap", { clear = true }),
    pattern = { "markdown", "typst" },
    callback = function()
        vim.wo.wrap = true
    end,
    desc = "Set wrap = true",
})

-- Add two coloured columns at 50 and 72 characters when writing commit messages
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("CommitMessageColorColumn", { clear = true }),
    pattern = { "gitcommit", "jj" },
    callback = function()
        vim.wo.colorcolumn = "50,72"
    end,
    desc = "Set colorcolumn = 50,72",
})

-- Add a comment string to git config files so I can comment things out
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("SetCommentString", { clear = true }),
    pattern = "gitconfig",
    callback = function()
        vim.bo.commentstring = "# %s"
    end,
    desc = 'Set commentstring = "# %s"',
})

-- Don't hide the special syntax used in help files
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("HelpConcealLevel", { clear = true }),
    pattern = "help",
    callback = function()
        vim.wo.conceallevel = 0
    end,
    desc = "Set conceallevel = 0",
})

-- Enable cfilter plugin for quickfix list (See :h cfilter-plugin)
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    group = vim.api.nvim_create_augroup("PackaddCfilter", { clear = true }),
    callback = function()
        -- :h pack-add says we need a bang, but this doesn't load the plugin,
        -- it only adds the files to 'runtimepath' - given that lazy.nvim is
        -- managing the runtimepath lets just add it normally.
        vim.cmd.packadd { "cfilter" }
    end,
    desc = "Run :packadd cfilter",
})
