require("peter.config.lsp.diagnostic")

local lspconfig = require("lspconfig")
local remap = require("peter.remap")

-- Add a rounded border to docs hovers
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = "rounded"})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local function custom_attach(_, bufnr)
    -- TODO: I would like some lightbulbs
    -- TODO: nvim-cmp-lsp-signature-help?
    -- TODO: (Auto) formatting

    local nnoremap = remap.bind("n", {buffer = bufnr})

    nnoremap("K", vim.lsp.buf.hover, {desc = "View docs under cursor"})
    nnoremap("gd", "<Cmd>lua require('telescope.builtin').lsp_definitions()<CR>", {desc = "Go to definition"})
    nnoremap("gT", "<Cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>", {desc = "Go to type definition"})
    nnoremap("gI", "<Cmd>lua require('telescope.builtin').lsp_implementations()<CR>", {desc = "Go to implementation"})
    nnoremap("gr", "<Cmd>lua require('telescope.builtin').lsp_references()<CR>", {desc = "Go to references"})

    nnoremap("<leader>cr", vim.lsp.buf.rename, {desc = "Rename"})
    nnoremap("<leader>ca", vim.lsp.buf.code_action, {desc = "Code action"})
end

-- TODO: Extract out settings into table

require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = {"sumneko_lua", "rust_analyzer"},
}
require("mason-lspconfig").setup_handlers {
    -- Default handler
    -- TODO: Factor out into function
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
                        libraryFiles = "Disable",
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
