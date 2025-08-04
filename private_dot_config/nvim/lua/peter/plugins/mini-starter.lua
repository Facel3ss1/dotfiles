---@module "lazy"
---@type LazySpec
return {
    {
        "nvim-mini/mini.starter",
        version = "*",
        event = "VimEnter",
        -- stylua: ignore
        keys = {
            { "<leader>us", function() require("mini.starter").open() end, desc = "Open Starter" }
        },
        opts = function()
            local starter = require("mini.starter")

            return {
                silent = true,
                items = {
                    starter.sections.recent_files(5, true),
                    {
                        { name = "Oil", action = "Oil", section = "Actions" },
                        { name = "Lazy", action = "Lazy", section = "Actions" },
                        { name = "Edit new buffer", action = "enew", section = "Actions" },
                        { name = "Quit Neovim", action = "qall", section = "Actions" },
                    },
                },
                content_hooks = {
                    starter.gen_hook.adding_bullet(),
                    starter.gen_hook.aligning("center", "center"),
                },
                header = function()
                    local ascii_art_lines = {
                        [[            _           ]],
                        [[ _ ____   _(_)_ __ ___  ]],
                        [[| '_ \ \ / / | '_ ` _ \ ]],
                        [[| | | \ V /| | | | | | |]],
                        [[|_| |_|\_/ |_|_| |_| |_|]],
                    }

                    return vim.iter(ascii_art_lines):join("\n")
                end,
                footer = function()
                    ---@type vim.Version
                    local vim_version = vim.version()
                    -- Only show commit hash in prerelease builds
                    if not vim_version.prerelease then
                        vim_version.build = nil
                    end
                    local vim_version_string = string.format("nvim v%s", tostring(vim_version))

                    local footer_lines = {
                        vim_version_string,
                    }

                    return vim.iter(footer_lines):join("\n")
                end,
            }
        end,
    },
}
