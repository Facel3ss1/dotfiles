local ok = pcall(require, "telescope")
if not ok then
    return
end

local nnoremap = require("peter.keymap").nnoremap

nnoremap("<leader>fd", require("telescope.builtin").find_files, {desc = "Find file"})
nnoremap("<leader>ft", require("telescope.builtin").git_files, {desc = "Find git file"})
nnoremap("<leader>fg", require("telescope.builtin").live_grep, {desc = "Live grep"})
nnoremap("<leader>fp", function()
    require("telescope.builtin").grep_string({
        search = vim.fn.input("Grep Prompt > "),
    })
end, {desc = "Grep prompt"})
nnoremap("<leader>fo", require("telescope.builtin").oldfiles, {desc = "Open recent file"})
nnoremap("<leader>fh", require("telescope.builtin").help_tags, {desc = "Find help"})
nnoremap("<leader>ff", function()
    local opt = require("telescope.themes").get_dropdown()
    require("telescope.builtin").current_buffer_fuzzy_find(opt)
end, {desc = "Fuzzy find in buffer"})

nnoremap("<leader>gb", require("telescope.builtin").git_branches, {desc = "Branches"})

nnoremap("<leader>fB", require("telescope.builtin").builtin, {desc = "Telescope builtin"})
