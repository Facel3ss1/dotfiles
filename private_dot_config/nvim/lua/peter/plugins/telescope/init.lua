local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup {
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
        file_browser = {
            theme = "ivy",
        },
    },
}

-- The fzf plugin is conditionally loaded by packer, so may not be available
pcall(telescope.load_extension, "fzf")
telescope.load_extension("notify")
telescope.load_extension("file_browser")
