require("indent_blankline").setup {
    show_current_context = true,
    buftype_exclude = { "terminal", "nofile" },
    filetype_exclude = {
        "help",
        "checkhealth",
        "packer",
    },
}
