local nnoremap = require("peter.remap").nnoremap

local function grep_prompt()
    vim.ui.input({kind = "grepprompt", prompt = "Grep Prompt: "}, function(input)
        if input ~= nil then
            require("telescope.builtin").grep_string({search = input})
        end
    end)
end

-- Opens the file browser in the containing folder of the current buffer
local function file_browser_in_containing_folder()
    require("telescope").extensions.file_browser.file_browser({path = "%:p:h"})
end

nnoremap("<leader>fd", "<Cmd>lua require('telescope.builtin').find_files()<CR>", {desc = "Find file"})
nnoremap("<leader>ft", "<Cmd>lua require('telescope.builtin').git_files()<CR>", {desc = "Find git file"})
nnoremap("<leader>fg", "<Cmd>lua require('telescope.builtin').live_grep()<CR>", {desc = "Live grep"})
nnoremap("<leader>fG", grep_prompt, {desc = "Grep prompt"})
nnoremap("<leader>fo", "<Cmd>lua require('telescope.builtin').oldfiles()<CR>", {desc = "Open recent file"})
nnoremap("<leader>fh", "<Cmd>lua require('telescope.builtin').help_tags()<CR>", {desc = "Find help"})
nnoremap("<leader>ff", "<Cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>", {desc = "Fuzzy find in buffer"})
nnoremap("<leader>fe", "<Cmd>lua require('telescope').extensions.file_browser.file_browser()<CR>", {desc = "Open file browser"})
nnoremap("<leader>fE", file_browser_in_containing_folder, {desc = "Open file browser in containing folder"})
nnoremap("<leader>fm", "<Cmd>lua require('telescope.builtin').man_pages()<CR>", {desc = "Find man page"})
nnoremap("<leader>fB", "<Cmd>lua require('telescope.builtin').builtin()<CR>", {desc = "Telescope builtin"})

nnoremap("<leader>gb", "<Cmd>lua require('telescope.builtin').git_branches()<CR>", {desc = "Branches"})
