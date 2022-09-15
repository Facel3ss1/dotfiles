local ok, fidget = pcall(require, "fidget")
if not ok then
    return
end

fidget.setup {
    text = {
        spinner = "dots",
    },
    timer = {
        spinner_rate = 75,
    },
    align = {
        bottom = false,
    }
}
