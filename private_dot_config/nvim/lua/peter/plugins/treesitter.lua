local util = require("peter.util")

---@module "lazy"
---@type LazySpec
return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main", -- FIXME: Remove once main is the default
        lazy = false, -- This plugin does not support lazy loading
        build = ":TSUpdate",
        config = function()
            local nvim_treesitter = require("nvim-treesitter")

            local ensure_installed = {
                "css",
                "diff",
                "dockerfile",
                "fish",
                "git_config",
                "git_rebase",
                "gitattributes",
                "gitcommit",
                "gitignore",
                "html",
                "javascript",
                "jsdoc",
                "json",
                "jsonc",
                "just",
                "nix",
                "powershell",
                "regex",
                "rust",
                "sql",
                "toml",
                "tsx",
                "typescript",
                "xml",
                "yaml",
            }

            local already_installed = nvim_treesitter.get_installed()
            local parsers_to_install = vim.iter(ensure_installed)
                :filter(function(parser)
                    return not vim.tbl_contains(already_installed, parser)
                end)
                :totable()

            if #parsers_to_install > 0 then
                nvim_treesitter.install(parsers_to_install)
            end

            -- Attempt to start treesitter for every file type
            local start_treesitter_group = vim.api.nvim_create_augroup("PeterStartTreesitter", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                group = start_treesitter_group,
                callback = function()
                    -- Will be false for filetypes with no treesitter parser installed
                    local _has_started = pcall(vim.treesitter.start)
                end,
            })
        end,
        cond = util.executable("tree-sitter"),
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        version = "*",
        module = false,
        event = "BufReadPre",
        config = true,
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
}
