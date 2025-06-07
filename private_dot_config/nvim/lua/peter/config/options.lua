local util = require("peter.util")

vim.o.mouse = "a" -- Let me use the mouse for scrolling etc.
vim.o.confirm = true -- Open confirm dialog when there are unsaved changes
vim.o.updatetime = 250 -- Trigger CursorHold etc. after 250ms
vim.o.title = true -- Display filename etc. in the title of the window

vim.o.number = true -- Show line numbers
vim.o.relativenumber = false -- Don't use relative line numbers

-- Wrapping
vim.o.wrap = false -- Turn off line wrapping. However, if we do wrap...
vim.o.breakindent = true -- ...preserve indentation...
vim.o.linebreak = true -- ...prevent words from splitting into two...
vim.o.smoothscroll = true --  ...and scroll using screen lines

vim.o.scrolloff = 10 -- There will be 10 lines above and below my cursor when scrolling
vim.o.sidescrolloff = 5 -- 5 columns to the side of my cursor when horizontally scrolling
vim.o.scrollback = 100000 -- 100,000 line scrollback in terminal buffers

-- Indentation defaults
-- Note that an .editorconfig file in the current directory can override these settings for configured file types
-- See :h editorconfig.indent_size and :h editorconfig.ident_style
vim.o.tabstop = 4 -- <Tab> characters will be displayed as 4 characters wide
vim.o.shiftwidth = 4 -- >, <, and = will work in increments of 4 characters
vim.o.softtabstop = -1 -- Always indent shiftwidth characters when we press <Tab>, even if tabstop > shiftwidth
vim.o.expandtab = true -- Use spaces instead of tabs for indentation
vim.o.shiftround = true -- Round indent to multiple of shiftwidth to prevent an off-by-one number of spaces

vim.o.autoindent = true -- Continue indentation from previous line
vim.o.smartindent = true -- Smartly add indentation when starting new line

vim.o.ignorecase = true -- Searching is case-insensitive by default. Use \C to make it case-sensitive
vim.o.smartcase = true -- But, if the search contains uppercase characters, make it case-sensitive

vim.o.undofile = true -- Save/Restore undo history to the undo directory when I save/load a file
-- FIXME: Change backupdir
-- vim.o.backup = true -- Save a backup to the backup directory when I save a file

vim.o.cursorline = true -- Highlight current line cursor is on
vim.o.signcolumn = "yes" -- Always show the sign column
vim.o.laststatus = 3 -- Use global statusline
-- TODO: statuscolumn

-- TODO: linematch
vim.opt.diffopt:append("algorithm:histogram")
vim.opt.fillchars = {
    diff = "╱",
}
vim.opt.shortmess:append("I") -- Don't show the intro on startup

vim.o.virtualedit = "block" -- Let me move to non-existent characters with <C-v>

vim.o.splitright = true -- Split windows to the right...
vim.o.splitbelow = true -- ...and downwards
vim.o.splitkeep = "topline" -- Don't move text when splitting

-- Use powershell on Windows (see :h shell-powershell)
if util.has("win32") then
    vim.o.shell = util.executable("pwsh") and "pwsh" or "powershell"
    vim.o.shellcmdflag =
        "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
    vim.o.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
    vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
end

vim.o.keywordprg = ":help" -- Check internal help when using K

vim.o.exrc = true -- Run .exrc, .nvimrc and .nvim.lua files in the current directory (See :h trust)
