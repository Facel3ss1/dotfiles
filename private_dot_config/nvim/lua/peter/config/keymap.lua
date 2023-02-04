-- Space is the leader key, so remove the default behaviour
-- This will also make which-key show when we press space
vim.keymap.set("n", "<Space>", "<Nop>")

-- Make j and k take line wrapping into account
-- If we supply a count beforehand, use default behaviour
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Bri'ish version of # key
vim.keymap.set("n", "£", "#")

-- Make <Esc> clear search highlights
-- TODO: Clear when we don't press a search key
vim.keymap.set("n", "<Esc>", "<Cmd>nohl<CR>")

-- TODO: Map this in operator pending mode so it is a text object
-- See https://www.vikasraj.dev/blog/vim-dot-repeat
vim.keymap.set("n", "cn", "*Ncgn", { desc = "Change next occurance of word under cursor" })
vim.keymap.set("n", "cN", "*NcgN", { desc = "Change previous occurance of word under cursor" })

vim.keymap.set("n", "<A-j>", ":.m .+1<CR>==", { desc = "Move line up", silent = true })
vim.keymap.set("n", "<A-k>", ":.m .-2<CR>==", { desc = "Move line down", silent = true })
vim.keymap.set("x", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move line up", silent = true })
vim.keymap.set("x", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move line down", silent = true })
vim.keymap.set("i", "<A-j>", "<Esc>:.m .+1<CR>==gi", { desc = "Move line up", silent = true })
vim.keymap.set("i", "<A-k>", "<Esc>:.m .-2<CR>==gi", { desc = "Move line down", silent = true })

-- Backspace in select mode changes instead of deletes
vim.keymap.set("s", "<BS>", "<C-g>c")

-- Repeatable indenting
vim.keymap.set("x", ">", ">gv")
vim.keymap.set("x", "<", "<gv")

-- Recenter screen after certain movements
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- FIXME: This doesn't work in Lua yet
-- See https://github.com/neovim/neovim/pull/22048
-- @ in visual mode
-- https://github.com/stoeffel/.dotfiles/blob/master/vim/visual-at.vim
vim.cmd([[
    function! ExecuteMacroOverVisualRange()
        echo "@".getcmdline()
        execute ":'<,'>normal @".nr2char(getchar())
    endfunction
]])
vim.keymap.set("x", "@", ":<C-u>call ExecuteMacroOverVisualRange()<CR>")
