-- TODO: Automatically update installed packages
require("mason").setup {
    ui = {
        border = "rounded",
        icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "●",
        },
    },
}
