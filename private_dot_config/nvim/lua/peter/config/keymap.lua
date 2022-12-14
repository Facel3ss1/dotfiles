local remap = require("peter.remap")
local nnoremap = remap.nnoremap
local xnoremap = remap.xnoremap
local inoremap = remap.inoremap
local snoremap = remap.snoremap

-- Space is the leader key, so remove the default behaviour
-- This will also make which-key show when we press space
nnoremap("<Space>", "<Nop>")

-- Make j and k take line wrapping into account
-- If we supply a count beforehand, use default behaviour
nnoremap("j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
nnoremap("k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Bri'ish version of # key
nnoremap("£", "#")

-- Make <Esc> clear search highlights
nnoremap("<Esc>", "<Cmd>nohl<CR>")

-- TODO: Map this in operator pending mode so it is a text object
-- See https://www.vikasraj.dev/blog/vim-dot-repeat
nnoremap("cn", "*Ncgn", { desc = "Change next occurance of word under cursor" })
nnoremap("cN", "*NcgN", { desc = "Change previous occurance of word under cursor" })

nnoremap("<A-j>", ":.m .+1<CR>==", { desc = "Move line up", silent = true })
nnoremap("<A-k>", ":.m .-2<CR>==", { desc = "Move line down", silent = true })
xnoremap("<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move line up (visual)", silent = true })
xnoremap("<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move line down (visual)", silent = true })
inoremap("<A-j>", "<Esc>:.m .+1<CR>==gi", { desc = "Move line up (insert)", silent = true })
inoremap("<A-k>", "<Esc>:.m .-2<CR>==gi", { desc = "Move line down (insert)", silent = true })

-- Backspace in select mode changes instead of deletes
snoremap("<BS>", "<C-g>c")

-- Repeatable indenting
xnoremap(">", ">gv")
xnoremap("<", "<gv")

-- Recenter screen after certain movements
nnoremap("n", "nzz")
nnoremap("N", "Nzz")
nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")

-- TODO: vim-unimpaired
nnoremap("]q", "<Cmd>cnext<CR>zz", { desc = "Next quickfix item" })
nnoremap("[q", "<Cmd>cprev<CR>zz", { desc = "Previous quickfix item" })
nnoremap("]l", "<Cmd>lnext<CR>zz", { desc = "Next location list item" })
nnoremap("[l", "<Cmd>lprev<CR>zz", { desc = "Previous location list item" })
nnoremap("]Q", "<Cmd>clast<CR>zz", { desc = "Last quickfix item" })
nnoremap("[Q", "<Cmd>cfirst<CR>zz", { desc = "First quickfix item" })
nnoremap("]L", "<Cmd>llast<CR>zz", { desc = "Last location list item" })
nnoremap("[L", "<Cmd>lfirst<CR>zz", { desc = "First location list item" })

-- FIXME: This doesn't work in Lua yet
-- @ in visual mode
-- https://github.com/stoeffel/.dotfiles/blob/master/vim/visual-at.vim
vim.cmd([[
    function! ExecuteMacroOverVisualRange()
        echo "@".getcmdline()
        execute ":'<,'>normal @".nr2char(getchar())
    endfunction
]])
xnoremap("@", ":<C-u>call ExecuteMacroOverVisualRange()<CR>")
