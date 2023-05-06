local util = require("peter.util")

-- TODO: Change horizontal split to <C-s>
return {
    {
        "nvim-telescope/telescope.nvim",
        version = "0.1.*",
        cmd = "Telescope",
        keys = {
            {
                "<leader>fd",
                function()
                    local opts = {}
                    local builtin = "find_files"
                    if vim.loop.fs_stat(vim.loop.cwd() .. "/.git") then
                        opts.show_untracked = true
                        -- FIXME: Don't show deleted files?
                        builtin = "git_files"
                    end

                    require("telescope.builtin")[builtin](opts)
                end,
                desc = "Find file",
            },
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
            { "<leader>ff", "<Cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Fuzzy find in buffer" },
            { "<leader>f/", "<Cmd>Telescope file_browser files=false<CR>", desc = "Open folder browser" },
            {
                "<leader>f.",
                -- FIXME: Use cwd when in terminal buffer
                "<Cmd>Telescope file_browser path=%:p:h<CR>",
                desc = "Open file browser in containing folder",
            },
            { "<leader>fx", "<Cmd>Telescope diagnostics<CR>", desc = "Find diagnostic" },

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
                extensions = {
                    -- TODO: Unmap backspace
                    file_browser = {
                        theme = "ivy",
                        respect_gitignore = false,
                    },
                },
            }
        end,
        config = function(_, opts)
            local telescope = require("telescope")
            telescope.setup(opts)

            -- The fzf plugin is only loaded when `make` is installed, so may not be available
            pcall(telescope.load_extension, "fzf")
            telescope.load_extension("notify")
            telescope.load_extension("file_browser")
        end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = util.executable("make") },
            "nvim-telescope/telescope-file-browser.nvim",
        },
    },
}
