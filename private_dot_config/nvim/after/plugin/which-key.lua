local ok, whichkey = pcall(require, "which-key")
if not ok then
    return
end

whichkey.register({
    c = {
        name = "code"
    },
    f = {
        name = "find",
    },
    g = {
        name = "git",
    },
}, {prefix = "<leader>"})

whichkey.setup {
    window = {
        winblend = 5,
    },
}
