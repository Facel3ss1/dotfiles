local ok, comment = pcall(require, "Comment")
if not ok then
    return
end

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
