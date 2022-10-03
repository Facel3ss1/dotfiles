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

local function search_config()
    local config_dir = vim.fn.expand("~") .. "/.local/share/chezmoi/private_dot_config/nvim/"
    -- TODO: :tcd on enter? Open in new tab?
    require("telescope.builtin").find_files({cwd = config_dir})
end

nnoremap("<leader>fd", "<Cmd>lua require('telescope.builtin').find_files()<CR>", {desc = "Find file"})
nnoremap("<leader>ft", "<Cmd>lua require('telescope.builtin').git_files()<CR>", {desc = "Find git file"})
nnoremap("<leader>fg", "<Cmd>lua require('telescope.builtin').live_grep()<CR>", {desc = "Live grep"})
nnoremap("<leader>fG", grep_prompt, {desc = "Grep prompt"})
nnoremap("<leader>fo", "<Cmd>lua require('telescope.builtin').oldfiles()<CR>", {desc = "Open recent file"})
nnoremap("<leader>ff", "<Cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>", {desc = "Fuzzy find in buffer"})
nnoremap("<leader>fe", "<Cmd>lua require('telescope').extensions.file_browser.file_browser()<CR>", {desc = "Open file browser"})
nnoremap("<leader>fE", file_browser_in_containing_folder, {desc = "Open file browser in containing folder"})
nnoremap("<leader>fv", search_config, {desc = "Find in config"})
nnoremap("<leader>fx", "<Cmd>lua require('telescope.builtin').diagnostics()<CR>", {desc = "Find diagnostic"})

nnoremap("<leader>hh", "<Cmd>lua require('telescope.builtin').help_tags()<CR>", {desc = "Help pages"})
nnoremap("<leader>hc", "<Cmd>lua require('telescope.builtin').commands()<CR>", {desc = "Commands"})
nnoremap("<leader>hb", "<Cmd>lua require('telescope.builtin').builtin()<CR>", {desc = "Telescope builtin pickers"})
nnoremap("<leader>hm", "<Cmd>lua require('telescope.builtin').man_pages()<CR>", {desc = "Man pages"})
nnoremap("<leader>hk", "<Cmd>lua require('telescope.builtin').keymaps()<CR>", {desc = "Keymaps"})
nnoremap("<leader>hl", "<Cmd>lua require('telescope.builtin').highlights()<CR>", {desc = "Highlights"})
nnoremap("<leader>hf", "<Cmd>lua require('telescope.builtin').filetypes()<CR>", {desc = "File types"})
nnoremap("<leader>ho", "<Cmd>lua require('telescope.builtin').vim_options()<CR>", {desc = "Options"})
nnoremap("<leader>ha", "<Cmd>lua require('telescope.builtin').autocommands()<CR>", {desc = "Autocommands"})

nnoremap("<leader>gb", "<Cmd>lua require('telescope.builtin').git_branches()<CR>", {desc = "Branches"})
