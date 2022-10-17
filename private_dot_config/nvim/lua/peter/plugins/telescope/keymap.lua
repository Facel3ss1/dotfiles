local nnoremap = require("peter.remap").nnoremap

local function grep_prompt()
    vim.ui.input({ kind = "grepprompt", prompt = "Grep Prompt: " }, function(input)
        if input ~= nil then
            require("telescope.builtin").grep_string { search = input }
        end
    end)
end

-- Opens the file browser in the containing folder of the current buffer
local function file_browser_in_containing_folder()
    require("telescope").extensions.file_browser.file_browser { path = "%:p:h" }
end

local function search_config()
    local config_dir = require("peter.chezmoi").source_dir .. "/private_dot_config/nvim/"
    -- TODO: :tcd on enter? Open in new tab?
    require("telescope.builtin").find_files { cwd = config_dir }
end

nnoremap("<leader>fd", "<Cmd>Telescope find_files<CR>", { desc = "Find file" })
nnoremap("<leader>ft", "<Cmd>Telescope git_files<CR>", { desc = "Find git file" })
nnoremap("<leader>fg", "<Cmd>Telescope live_grep<CR>", { desc = "Live grep" })
nnoremap("<leader>fG", grep_prompt, { desc = "Grep prompt" })
nnoremap("<leader>fo", "<Cmd>Telescope oldfiles<CR>", { desc = "Open recent file" })
nnoremap("<leader>ff", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Fuzzy find in buffer" })
nnoremap("<leader>fe", "<Cmd>Telescope file_browser<CR>", { desc = "Open file browser" })
nnoremap("<leader>fE", file_browser_in_containing_folder, { desc = "Open file browser in containing folder" })
nnoremap("<leader>fv", search_config, { desc = "Find in config" })
nnoremap("<leader>fx", "<Cmd>Telescope diagnostics<CR>", { desc = "Find diagnostic" })

nnoremap("<leader>hh", "<Cmd>Telescope help_tags<CR>", { desc = "Help pages" })
nnoremap("<leader>hc", "<Cmd>Telescope commands<CR>", { desc = "Commands" })
nnoremap("<leader>hb", "<Cmd>Telescope builtin<CR>", { desc = "Telescope builtin pickers" })
nnoremap("<leader>hm", "<Cmd>Telescope man_pages<CR>", { desc = "Man pages" })
nnoremap("<leader>hk", "<Cmd>Telescope keymaps<CR>", { desc = "Keymaps" })
nnoremap("<leader>hl", "<Cmd>Telescope highlights<CR>", { desc = "Highlights" })
nnoremap("<leader>hf", "<Cmd>Telescope filetypes<CR>", { desc = "File types" })
nnoremap("<leader>ho", "<Cmd>Telescope vim_options<CR>", { desc = "Options" })
nnoremap("<leader>ha", "<Cmd>Telescope autocommands<CR>", { desc = "Autocommands" })
nnoremap("<leader>hn", "<Cmd>Telescope notify<CR>", { desc = "Notifications" })

nnoremap("<leader>gb", "<Cmd>Telescope git_branches<CR>", { desc = "Branches" })
