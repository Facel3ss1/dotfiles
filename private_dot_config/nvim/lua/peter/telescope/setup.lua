local ok, telescope = pcall(require, "telescope")
if not ok then
    return
end

local actions = require("telescope.actions")

telescope.setup {
    defaults = {
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
        help_tags = { theme = "ivy" },
        oldfiles = { theme = "ivy" },
        git_branches = { theme = "dropdown" },
        git_status = {
            git_icons = {
                changed = "M",
            },
        },
    },
}

telescope.load_extension("fzf")
telescope.load_extension("notify")
