require("dressing").setup {
    input = {
        insert_only = false,
        winblend = 0,
        get_config = function(opts)
            if opts.kind == "grepprompt" then
                return {
                    insert_only = true,
                    relative = "editor",
                }
            end
        end,
    },
    select = {
        get_config = function(opts)
            if opts.kind == "codeaction" then
                return {
                    telescope = require("telescope.themes").get_cursor(),
                }
            end
        end,
    }
}
