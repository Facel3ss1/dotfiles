local ok = pcall(require, "telescope")
if not ok then
    return
end

local nnoremap = require("peter.keymap").nnoremap

nnoremap("<leader>fd", require("telescope.builtin").find_files)
nnoremap("<leader>fg", require("telescope.builtin").live_grep)
nnoremap("<leader>fh", require("telescope.builtin").help_tags)

nnoremap("<leader>fB", require("telescope.builtin").builtin)
