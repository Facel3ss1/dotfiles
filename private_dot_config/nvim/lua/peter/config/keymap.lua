local remap = require("peter.remap")
local nnoremap = remap.nnoremap
local xnoremap = remap.xnoremap
local inoremap = remap.inoremap
local snoremap = remap.snoremap

-- Make j and k take line wrapping into account
-- If we supply a count beforehand, use default behaviour
nnoremap("j", "v:count == 0 ? 'gj' : 'j'", {expr = true, silent = true})
nnoremap("k", "v:count == 0 ? 'gk' : 'k'", {expr = true, silent = true})

-- Bri'ish version of # key
nnoremap("£", "#")

-- Make <Esc> clear search highlights
nnoremap("<Esc>", "<Cmd>nohl<CR>")

nnoremap("gw", "*N", {desc = "Search word under cursor"})
xnoremap("gw", "*N", {desc = "Search word under cursor (visual)"})

nnoremap("<A-j>", ":.m .+1<CR>==", {desc = "Move line up", silent = true})
nnoremap("<A-k>", ":.m .-2<CR>==", {desc = "Move line down", silent = true})
xnoremap("<A-j>", ":m '>+1<CR>gv=gv", {desc = "Move line up (visual)", silent = true})
xnoremap("<A-k>", ":m '<-2<CR>gv=gv", {desc = "Move line down (visual)", silent = true})
inoremap("<A-j>", "<Esc>:.m .+1<CR>==gi", {desc = "Move line up (insert)", silent = true})
inoremap("<A-k>", "<Esc>:.m .-2<CR>==gi", {desc = "Move line down (insert)", silent = true})

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

-- TODO: Wrapping
-- TODO: ]Q etc for first and last?
nnoremap("]q", "<Cmd>cnext<CR>zz", {desc = "Next quickfix item"})
nnoremap("[q", "<Cmd>cprev<CR>zz", {desc = "Previous quickfix item"})

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
