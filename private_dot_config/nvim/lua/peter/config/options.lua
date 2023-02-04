vim.o.mouse = "a" -- Let me use the mouse for scrolling etc.
vim.o.confirm = true -- Open confirm dialog when there are unsaved changes
vim.o.updatetime = 250 -- Trigger CursorHold etc. after 250ms

vim.o.relativenumber = true -- Show relative line numbers...
vim.o.number = true -- ...and show the current line number

-- Wrapping
vim.o.wrap = false -- Turn off line wrapping. However, if we do wrap...
vim.o.breakindent = true -- ...preserve indentation...
vim.o.linebreak = true -- ...and prevent words from splitting into two

vim.o.scrolloff = 10 -- There will be 10 lines above and below my cursor when scrolling
vim.o.sidescrolloff = 5 -- 5 columns to the side of my cursor when horizontally scrolling
vim.o.scrollback = 100000 -- 100,000 line scrollback in terminal buffers

-- Indentation defaults
vim.o.tabstop = 4 -- <Tab> characters will be displayed as 4 characters wide
vim.o.shiftwidth = 4 -- >, <, and = will work in increments of 4 characters
vim.o.softtabstop = -1 -- Always indent shiftwidth characters when we press <Tab>, even if tabstop > shiftwidth
vim.o.expandtab = true -- Use spaces instead of tabs for indentation

vim.o.autoindent = true -- Continue indentation from previous line
vim.o.smartindent = true -- Smartly add indentation when starting new line

vim.o.ignorecase = true -- Searching is case-insensitive by default. Use \C to make it case-sensitive

-- TODO: undofile?
-- TODO: backup and backupdir?

vim.o.colorcolumn = "80" -- Put colored column at column 80
vim.o.cursorline = true -- Highlight current line cursor is on
vim.o.signcolumn = "yes" -- Always show the sign column
vim.o.laststatus = 3 -- Use global statusline

vim.opt.fillchars = {
    diff = "╱",
}
vim.opt.shortmess:append("I") -- Don't show the intro on startup

vim.o.virtualedit = "block"

-- Split windows to the right and downwards
vim.o.splitright = true
vim.o.splitbelow = true

-- Use powershell on Windows (see :h shell-powershell)
if vim.fn.has("win32") == 1 then
    vim.o.shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"
    vim.o.shellcmdflag =
        "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
    vim.o.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
    vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
    vim.o.shellquote = ""
    vim.o.shellxquote = ""
end

-- Allow me to use gx to open URLs and files
if vim.fn.executable("wslview") == 1 then
    vim.g.netrw_browsex_viewer = "wslview"
elseif vim.fn.has("win32") == 1 then
    vim.g.netrw_browsex_viewer = "start"
elseif vim.fn.executable("xdg-open") == 1 then
    vim.g.netrw_browsex_viewer = "xdg-open"
elseif vim.fn.has("mac") == 1 then
    vim.g.netrw_browsex_viewer = "open"
end

if vim.fn.executable("rg") == 1 then
    -- TODO: Don't search hidden files?
    vim.o.grepprg = "rg --vimgrep --hidden --glob '!.git'" -- Use ripgrep instead of grep
    vim.o.grepformat = "%f:%l:%c:%m" -- ripgrep's output format
end

-- vim.o.guifont = "JetBrainsMono NF:h10"
