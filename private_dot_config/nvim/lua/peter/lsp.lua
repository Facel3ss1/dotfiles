local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
    return
end

local keymap = require("peter.keymap")

-- Add a rounded border to docs hovers
vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, {border = "rounded"})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local function custom_attach()
    -- TODO: I would like some lightbulbs

    local nnoremap = keymap.bind("n", {buffer = 0})

    nnoremap("K", vim.lsp.buf.hover, {desc = "View docs under cursor"})
    nnoremap("gd", require("telescope.builtin").lsp_definitions, {desc = "Go to definition"})
    nnoremap("gT", require("telescope.builtin").lsp_type_definitions, {desc = "Go to type definition"})
    nnoremap("gI", require("telescope.builtin").lsp_implementations, {desc = "Go to implementation"})
    nnoremap("gr", require("telescope.builtin").lsp_references, {desc = "Go to references"})

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
            capabilities = capabilities,
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
            capabilities = capabilities,
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