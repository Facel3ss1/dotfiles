-- FIXME: Use vim.o (see https://github.com/neovim/neovim/pull/19982 and https://github.com/neovim/neovim/issues/20107)
local opt = vim.opt

opt.mouse = "a" -- Let me use the mouse for scrolling etc.
opt.confirm = true -- Open confirm dialog when there are unsaved changes
opt.updatetime = 250 -- Trigger CursorHold etc. after 250ms

opt.relativenumber = true -- Show relative line numbers...
opt.number = true -- ...and show the current line number

-- Wrapping
opt.wrap = false -- Turn off line wrapping. However, if we do wrap...
opt.breakindent = true -- ...preserve indentation...
opt.linebreak = true -- ...and prevent words from splitting into two

opt.scrolloff = 10 -- There will be 10 lines above and below my cursor when scrolling
opt.sidescrolloff = 5 -- 5 columns to the side of my cursor when horizontally scrolling

-- Indentation defaults
opt.tabstop = 4 -- <Tab> characters will be displayed as 4 characters wide
opt.shiftwidth = 4 -- >, <, and = will work in increments of 4 characters
opt.softtabstop = -1 -- Always indent shiftwidth characters when we press <Tab>, even if tabstop > shiftwidth
opt.expandtab = true -- Use spaces instead of tabs for indentation

opt.autoindent = true -- Continue indentation from previous line
opt.smartindent = true -- Smartly add indentation when starting new line

opt.hlsearch = true -- Highlight search results, I've mapped <Esc> to :nohl

-- TODO: undofile?

-- TODO: Disable for certain filetypes (quickfix, etc.)
opt.colorcolumn = "80" -- Put colored column at column 80
opt.cursorline = true -- Highlight current line cursor is on
opt.signcolumn = "yes" -- Always show the sign column
opt.laststatus = 3 -- Use global statusline

opt.fillchars = {
    diff = "╱",
}

opt.virtualedit = "block"

-- Split windows to the right and downwards
opt.splitright = true
opt.splitbelow = true

if vim.fn.executable("rg") == 1 then
    opt.grepprg = "rg --vimgrep --hidden --glob '!.git'" -- Use ripgrep instead of grep
    opt.grepformat = "%f:%l:%c:%m" -- ripgrep's output format
end
