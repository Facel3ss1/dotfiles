require("peter.plugins.lsp.handlers")
require("peter.plugins.lsp.diagnostic")

local remap = require("peter.remap")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local function custom_attach(_, bufnr)
    -- TODO: I would like some lightbulbs
    -- TODO: nvim-cmp-lsp-signature-help?
    -- TODO: (Auto) formatting

    local nnoremap = remap.bind("n", {buffer = bufnr})

    nnoremap("K", vim.lsp.buf.hover, {desc = "View docs under cursor"})
    nnoremap("gd", vim.lsp.buf.definition, {desc = "Go to definition"})
    nnoremap("gT", "<Cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>", {desc = "Go to type definition"})
    nnoremap("gI", "<Cmd>lua require('telescope.builtin').lsp_implementations()<CR>", {desc = "Go to implementations"})
    nnoremap("gr", "<Cmd>lua require('telescope.builtin').lsp_references()<CR>", {desc = "Go to references"})

    nnoremap("<leader>fs", "<Cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>", {desc = "Find document symbol"})
    nnoremap("<leader>fS", "<Cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>", {desc = "Find workspace symbol"})

    nnoremap("<leader>cr", vim.lsp.buf.rename, {desc = "Rename"})
    nnoremap("<leader>ca", vim.lsp.buf.code_action, {desc = "Code action"})
end

require("mason-lspconfig").setup {
    ensure_installed = {"sumneko_lua", "rust_analyzer"},
}

local settings = {
    ["sumneko_lua"] = {
        Lua = {
            completion = {
                callSnippet = "Replace",
                postfix = ".",
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

local function default_handler(server_name)
    require("lspconfig")[server_name].setup {
        on_attach = custom_attach,
        capabilities = capabilities,
        settings = settings[server_name],
    }
end

require("mason-lspconfig").setup_handlers {
    default_handler,
    ["sumneko_lua"] = function(server_name)
        require("lua-dev").setup {
            override = function(root_dir, library)
                -- Make sure we enable lsp for the vim api in the chezmoi directory
                local chezmoi_dir = vim.fn.expand("~") .. "/.local/share/chezmoi/"
                if require("lua-dev.util").has_file(root_dir, chezmoi_dir) then
                    library.enabled = true
                    library.plugins = true
                end
            end,
        }

        default_handler(server_name)
    end,
    -- TODO: rust-tools
}
