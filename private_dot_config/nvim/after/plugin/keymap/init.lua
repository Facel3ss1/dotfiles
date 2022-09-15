local keymap = require("peter.keymap")
local nnoremap = keymap.nnoremap
local vnoremap = keymap.vnoremap
local inoremap = keymap.inoremap
local xnoremap = keymap.xnoremap
local snoremap = keymap.snoremap

-- TODO: @ in visual mode

-- Make j and k take line wrapping into account
nnoremap("j", "gj")
nnoremap("k", "gk")

-- Bri'ish version of # key
nnoremap("£", "#")

nnoremap("gw", "*N", {desc = "Search word under cursor"})
xnoremap("gw", "*N", {desc = "Search word under cursor (visual)"})

nnoremap("<A-j>", ":.m .+1<CR>==", {desc = "Move line up", silent = true})
nnoremap("<A-k>", ":.m .-2<CR>==", {desc = "Move line down", silent = true})
vnoremap("<A-j>", ":m '>+1<CR>gv=gv", {desc = "Move line up (visual)", silent = true})
vnoremap("<A-k>", ":m '<-2<CR>gv=gv", {desc = "Move line down (visual)", silent = true})
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
