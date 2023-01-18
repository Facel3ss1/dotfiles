-- TODO: Automatically update installed packages
-- TODO: Ensure stylua is installed?
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
