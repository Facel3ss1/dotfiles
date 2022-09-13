local ok, dressing = pcall(require, "dressing")
if not ok then
    return
end

dressing.setup {
    input = {
        winblend = 0,
        get_config = function(opts)
            if opts.kind == "grepprompt" then
                return {
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
