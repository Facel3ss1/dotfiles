local util = require("peter.util")

-- TODO: Change horizontal split to <C-s>

---@param show_ignored boolean
---@return function
local function find_files(show_ignored)
    return function()
        local builtin = "find_files"
        local opts = {
            hidden = true,
            no_ignore = show_ignored,
            prompt_title = show_ignored and "Find Files (including ignored)" or nil,
        }

        if show_ignored then
            require("telescope.builtin")[builtin](opts)
            return
        end

        if vim.uv.fs_stat(vim.uv.cwd() .. "/.git") then
            -- FIXME: Don't show deleted files?
            builtin = "git_files"
            opts = { show_untracked = true }
        end

        require("telescope.builtin")[builtin](opts)
    end
end

---@module "lazy"
---@type LazySpec
return {
    {
        "nvim-telescope/telescope.nvim",
        version = "*",
        cmd = "Telescope",
        keys = {
            -- FIXME: Based on `:h lsp-defaults` in 0.11
            { "grr", "<Cmd>Telescope lsp_references<CR>", desc = "Go to references" },
            { "gri", "<Cmd>Telescope lsp_implementations<CR>", desc = "Go to implementations" },
            { "grt", "<Cmd>Telescope lsp_type_definitions<CR>", desc = "Go to type definition" },
            { "gO", "<Cmd>Telescope lsp_document_symbols<CR>", desc = "Find document symbol" },

            { "<leader>fd", find_files(false), desc = "Find file" },
            { "<leader>fD", find_files(true), desc = "Find file (including ignored)" },
            { "<leader>fb", "<Cmd>Telescope buffers<CR>", desc = "Find buffer" },
            { "<leader>fg", "<Cmd>Telescope live_grep<CR>", desc = "Live grep" },
            {
                "<leader>fG",
                function()
                    vim.ui.input({ kind = "grepprompt", prompt = "Grep Prompt: " }, function(input)
                        if input ~= nil then
                            require("telescope.builtin").grep_string { search = input }
                        end
                    end)
                end,
                desc = "Grep prompt",
            },
            { "<leader>fo", "<Cmd>Telescope oldfiles<CR>", desc = "Open recent file" },
            { "<leader>fx", "<Cmd>Telescope diagnostics<CR>", desc = "Find diagnostic" },
            { "<leader>fs", "<Cmd>Telescope lsp_workspace_symbols<CR>", desc = "Find workspace symbol" },

            { "<leader>hh", "<Cmd>Telescope help_tags<CR>", desc = "Help pages" },
            { "<leader>hc", "<Cmd>Telescope commands<CR>", desc = "Commands" },
            { "<leader>hb", "<Cmd>Telescope builtin<CR>", desc = "Telescope builtin pickers" },
            { "<leader>hm", "<Cmd>Telescope man_pages<CR>", desc = "Man pages" },
            { "<leader>hk", "<Cmd>Telescope keymaps<CR>", desc = "Keymaps" },
            { "<leader>hl", "<Cmd>Telescope highlights<CR>", desc = "Highlights" },
            { "<leader>hf", "<Cmd>Telescope filetypes<CR>", desc = "File types" },
            { "<leader>ho", "<Cmd>Telescope vim_options<CR>", desc = "Options" },
            { "<leader>ha", "<Cmd>Telescope autocommands<CR>", desc = "Autocommands" },
            { "<leader>hn", "<Cmd>Telescope notify<CR>", desc = "Notifications" },

            { "<leader>gb", "<Cmd>Telescope git_branches<CR>", desc = "Branches" },
        },
        opts = function()
            local actions = require("telescope.actions")

            return {
                defaults = {
                    sorting_strategy = "ascending",
                    layout_config = {
                        prompt_position = "top",
                    },
                    mappings = {
                        ["i"] = {
                            ["<Up>"] = actions.cycle_history_prev,
                            ["<Down>"] = actions.cycle_history_next,
                        },
                    },
                },
                pickers = {
                    builtin = { theme = "ivy" },
                    current_buffer_fuzzy_find = {
                        theme = "dropdown",
                        previewer = false,
                    },
                    filetypes = { theme = "dropdown" },
                    git_branches = { theme = "dropdown" },
                    git_status = {
                        git_icons = {
                            changed = "M",
                        },
                    },
                    help_tags = { theme = "ivy" },
                    man_pages = {
                        theme = "ivy",
                        sections = { "ALL" },
                    },
                },
            }
        end,
        config = function(_, opts)
            local telescope = require("telescope")
            telescope.setup(opts)

            -- The fzf plugin is only loaded when `make` is installed, so it may not be available
            pcall(telescope.load_extension, "fzf")
            telescope.load_extension("notify")
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = util.executable("make") },
        },
    },
}
