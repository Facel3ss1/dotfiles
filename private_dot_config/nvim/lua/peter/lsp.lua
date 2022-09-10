local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
    return
end

local keymap = require("peter.keymap")

local function custom_attach()
    -- TODO: Use telesope pickers (cursor theme)
    -- TODO: I would like some lightbulbs

    local nnoremap = keymap.bind("n", {buffer = 0})

    nnoremap("K", vim.lsp.buf.hover, {desc = "View docs under cursor"})
    nnoremap("gd", vim.lsp.buf.definition, {desc = "Go to definition"})
    nnoremap("gT", vim.lsp.buf.type_definition, {desc = "Go to type definition"})
    nnoremap("gI", vim.lsp.buf.implementation, {desc = "Go to implementation"})
    nnoremap("gr", vim.lsp.buf.references, {desc = "Go to references"})

    nnoremap("<leader>cr", vim.lsp.buf.rename, {desc = "Rename"})
    nnoremap("<leader>ca", vim.lsp.buf.code_action, {desc = "Code action"})
end

require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = {"sumneko_lua", "rust_analyzer"},
}
require("mason-lspconfig").setup_handlers {
    -- Default handler
    function(server_name)
        require("lspconfig")[server_name].setup {
            on_attach = custom_attach,
        }
    end,
    ["sumneko_lua"] = function()
        require("lua-dev").setup {
            override = function(root_dir, library)
                -- Make sure we get lsp in the chezmoi directory
                local chezmoi_dir = vim.fn.expand("~") .. "/.local/share/chezmoi/"
                if require("lua-dev.util").has_file(root_dir, chezmoi_dir) then
                    library.enabled = true
                    library.plugins = true
                end
            end,
        }

        lspconfig.sumneko_lua.setup {
            on_attach = custom_attach,
            settings = {
                Lua = {
                    completion = {
                        callSnippet = "Replace",
                    },
                    diagnostics = {
                        globals = {
                            "describe",
                            "it",
                            "before_each",
                            "after_each",
                        },
                    },
                },
            },
        }
    end,
    -- TODO: rust-tools
}

-- TODO: Workspace loading indicator?
-- TODO: Formatting
