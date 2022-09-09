local keymap = require("peter.keymap")
local nnoremap = keymap.nnoremap
local vnoremap = keymap.vnoremap
local inoremap = keymap.inoremap

-- Make j and k take line wrapping into account
nnoremap("j", "gj")
nnoremap("k", "gk")

-- Bri'ish version of # key
nnoremap("£", "#")

-- Alt+J and Alt+K for moving lines up and down
nnoremap("<M-j>", ":.m .+1<CR>==", {desc = "Move line up", silent = true})
nnoremap("<M-k>", ":.m .-2<CR>==", {desc = "Move line down", silent = true})
vnoremap("<M-j>", ":m '>+1<CR>gv=gv", {desc = "Move line up (visual)", silent = true})
vnoremap("<M-k>", ":m '<-2<CR>gv=gv", {desc = "Move line down (visual)", silent = true})

-- Recenter screen after certain movements
nnoremap("n", "nzz")
nnoremap("N", "Nzz")
nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")
