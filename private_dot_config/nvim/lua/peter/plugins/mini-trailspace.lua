---@module "lazy"
---@type LazySpec
return {
    {
        "echasnovski/mini.trailspace",
        version = "*",
        event = "BufReadPre",
        config = function(_, opts)
            require("mini.trailspace").setup(opts)

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("peter.disable_mini_trailspace", { clear = true }),
                pattern = { "gitcommit", "jj" },
                callback = function(args)
                    vim.b[args.buf].minitrailspace_disable = true
                end,
                desc = "Disable mini.trailspace",
            })
        end,
    },
}
