local opt = vim.opt

opt.mouse = "a" -- Let me use the mouse for scrolling etc.
opt.confirm = true -- Open confirm dialog when there are unsaved changes

opt.relativenumber = true -- Show relative line numbers...
opt.number = true -- ...and show the current line number

opt.wrap = false -- Turn off line wrapping. However, if we do wrap...
opt.breakindent = true -- ...preserve indentation...
opt.linebreak = true -- ...and prevent words from splitting into two

opt.scrolloff = 10 -- There will be 10 lines above and below my cursor when scrolling
opt.sidescrolloff = 5 -- 5 columns to the side of my cursor when horizontally scrolling

opt.tabstop = 4 -- <Tab> characters will be displayed as 4 characters wide
opt.shiftwidth = 4 -- >, <, and = will work in increments of 4 characters
opt.softtabstop = 4 -- We want each indentation level to be 4 characters
opt.expandtab = true -- Use spaces instead of tabs for indentation

opt.autoindent = true -- Continue indentation from previous line
opt.smartindent = true -- Smartly add indentation when starting new line

opt.hlsearch = true -- Highlight search results, I've mapped <Esc> to :nohl

-- TODO: Disable for certain filetypes (quickfix, etc.)
opt.colorcolumn = "80" -- Put colored column at column 80
opt.cursorline = true -- Highlight current line cursor is on
opt.signcolumn = "yes" -- Always show the sign column

-- Split windows to the right and downwards
opt.splitright = true
opt.splitbelow = true

if vim.fn.executable("rg") then
    opt.grepprg = "rg --vimgrep --hidden --glob '!.git'" -- Use ripgrep instead of grep
    opt.grepformat = "%f:%l:%c:%m" -- ripgrep's output format
end
