local ok, fidget = pcall(require, "fidget")
if not ok then
    return
end

fidget.setup {
    text = {
        spinner = "dots",
        done = "",
    },
    timer = {
        spinner_rate = 75,
    },
    align = {
        bottom = false,
    },
    window = {
        blend = 0,
        relative = "editor",
    },
}
