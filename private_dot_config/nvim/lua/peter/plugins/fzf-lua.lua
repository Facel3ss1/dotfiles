local util = require("peter.util")

-- Find TODOs etc in a project by pre-populating a grep search with a regex
local function grep_todos()
    local fzf_lua = require("fzf-lua")

    local keywords = { "TODO", "FIXME", "XXX", "HACK", "BUG", "PERF" }
    local keywords_regex = vim.iter(keywords):join("|")
    -- This regex searches for keywords followed by a colon, with an optional author in brackets
    local search_regex = string.gsub([[\b(KEYWORDS)(\([^\)]*\))?:]], "KEYWORDS", keywords_regex)

    fzf_lua.grep {
        search = search_regex,
        no_esc = true, -- Don't escape the regex
        prompt = "> ",
        multiline = 1,
        winopts = {
            title = "TODOs",
        },
    }
end

---@module "lazy"
---@type LazySpec
return {
    {
        "ibhagwan/fzf-lua",
        cmd = "FzfLua",
        keys = {
            -- Based on `:h lsp-defaults`
            { "grr", "<Cmd>FzfLua lsp_references<CR>", desc = "Go to references" },
            { "gri", "<Cmd>FzfLua lsp_implementations<CR>", desc = "Go to implementations" },
            { "grt", "<Cmd>FzfLua lsp_typedefs<CR>", desc = "Go to type definition" },
            { "gO", "<Cmd>FzfLua lsp_document_symbols<CR>", desc = "Find document symbol" },

            { "<leader>fd", "<Cmd>FzfLua files<CR>", desc = "Find file" },
            { "<leader>fg", "<Cmd>FzfLua live_grep<CR>", desc = "Live grep" },
            { "<leader>fx", "<Cmd>FzfLua diagnostics_workspace<CR>", desc = "Find workspace diagnostic" },
            { "<leader>ft", grep_todos, desc = "Find TODOs" },
            { "<leader>fs", "<Cmd>FzfLua lsp_workspace_symbols<CR>", desc = "Find workspace symbol" },
            { "<leader>fb", "<Cmd>FzfLua buffers<CR>", desc = "Find buffer" },
            { "<leader>fo", "<Cmd>FzfLua oldfiles<CR>", desc = "Open recent file" },

            { "<leader>hh", "<Cmd>FzfLua helptags<CR>", desc = "Help pages" },
            { "<leader>ha", "<Cmd>FzfLua autocmds<CR>", desc = "Autocommands" },
            { "<leader>hf", "<Cmd>FzfLua filetypes<CR>", desc = "Filetypes" },
            { "<leader>hk", "<Cmd>FzfLua keymaps<CR>", desc = "Keymaps" },
            { "<leader>hl", "<Cmd>FzfLua highlights<CR>", desc = "Highlights" },
            { "<leader>hb", "<Cmd>FzfLua builtin<CR>", desc = "FzfLua builtin commands" },
            { "<leader>ho", "<Cmd>FzfLua nvim_options<CR>", desc = "Nvim options" },
            { "<leader>hc", "<Cmd>FzfLua commands<CR>", desc = "Commands" },
            { "<leader>hm", "<Cmd>FzfLua manpages<CR>", desc = "Man pages" },
        },
        opts = function()
            local actions = require("fzf-lua.actions")

            return {
                { "border-fused" },
                fzf_colors = true, -- Set fzf's colors based on nvim colorscheme
                winopts = {
                    backdrop = 100, -- Don't fade out background
                },
                keymap = {
                    fzf = {
                        true, -- Inherit default keybinds
                        ["ctrl-q"] = "select-all+accept", -- Send results to quickfix list
                    },
                },
                defaults = {
                    git_icons = false,
                },
                files = {
                    cwd_prompt = false,
                },
                helptags = {
                    actions = {
                        ["enter"] = actions.help_vert, -- Open help pages in a vertical split
                    },
                },
                filetypes = {
                    winopts = {
                        width = 0.5,
                        height = 0.5,
                    },
                },
                autocmds = {
                    winopts = {
                        preview = {
                            layout = "vertical",
                        },
                    },
                },
            }
        end,
        init = function()
            -- When we first call vim.ui.select, register fzf-lua's implementation, which will override all subsequent invocations
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                local fzf_lua = require("fzf-lua")
                fzf_lua.register_ui_select {
                    winopts = {
                        width = 0.5,
                        height = 0.5,
                    },
                }

                vim.ui.select(...)
            end
        end,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cond = util.executable("fzf"),
    },
}
