require("null-ls").setup {
    sources = {
        require("null-ls").builtins.formatting.fish_indent,
        require("null-ls").builtins.diagnostics.fish,
    },
}
