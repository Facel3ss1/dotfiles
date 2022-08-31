local keymap = require("peter.keymap")
local imap = keymap.imap
local nmap = keymap.nmap
local nnoremap = keymap.nnoremap
local vnoremap = keymap.vnoremap
local xnoremap = keymap.xnoremap
local inoremap = keymap.inoremap

-- Make j and k take line wrapping into account
nnoremap("j", "gj")
nnoremap("k", "gk")

-- Bri'ish version of # key
nnoremap("£", "#")

-- Alt+J and Alt+K for moving lines up and down
vnoremap("<M-j>", ":m '>+1<CR>gv=gv")
vnoremap("<M-k>", ":m '<-2<CR>gv=gv")
nnoremap("<M-j>", ":.m .+1<CR>==", {silent = true})
nnoremap("<M-k>", ":.m .-2<CR>==", {silent = true})

-- Recenter screen after certain movements
nnoremap("n", "nzz")
nnoremap("N", "Nzz")
nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")

-- Make Ctrl-Backspace work in insert mode
-- imap("<C-H>", "<C-W>")
