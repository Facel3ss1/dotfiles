local ok, comment = pcall(require, "Comment")
if not ok then
    return
end

-- TODO: Use gbc for block comments so that we can eventually use gCC for help
comment.setup {
    toggler = {
        line = "gcc",
        block = "gCC",
    },
    opleader = {
        line = "gc",
        block = "gC",
    },
}
