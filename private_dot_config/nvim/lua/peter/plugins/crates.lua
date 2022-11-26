local augroup = require("peter.au").augroup
local remap = require("peter.remap")

local crates = require("crates")

local autocmd = augroup("CargoCrates", { clear = true })
autocmd("BufRead", {
    pattern = "Cargo.toml",
    callback = function(args)
        require("cmp").setup.buffer { sources = { { name = "crates" } } }

        local nnoremap = remap.bind("n", { buffer = args.buf })
        require("which-key").register({ c = { name = "crates" } }, { prefix = "<leader>c" })
        nnoremap("<leader>ccp", crates.show_crate_popup, { desc = "Show crate popup" })
        nnoremap("<leader>ccv", crates.show_versions_popup, { desc = "Show crate versions" })
        nnoremap("<leader>ccf", crates.show_features_popup, { desc = "Show crate features" })
        nnoremap("<leader>ccd", crates.show_dependencies_popup, { desc = "Show crate dependencies" })
    end,
})

crates.setup {
    null_ls = {
        enabled = true,
        name = "crates.nvim",
    },
}
