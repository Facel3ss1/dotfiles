require("peter.plugins.lsp.handlers")
require("peter.plugins.lsp.diagnostic")

local remap = require("peter.remap")
local augroup = require("peter.au").augroup

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local function on_attach(args)
    -- TODO: nvim-cmp-lsp-signature-help?
    -- TODO: (Auto) formatting
    -- TODO: Guard mappings behind capabilities checks?

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local cap = vim.lsp.protocol.resolve_capabilities(client.server_capabilities)

    local nnoremap = remap.bind("n", {buffer = args.buf})
    local vnoremap = remap.bind("v", {buffer = args.buf})

    nnoremap("K", vim.lsp.buf.hover, {desc = "View docs under cursor"})
    nnoremap("gd", vim.lsp.buf.definition, {desc = "Go to definition"})
    nnoremap("gD", vim.lsp.buf.declaration, {desc = "Go to declaration"})
    nnoremap("go", "<Cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>", {desc = "Go to type definition"})
    nnoremap("gI", "<Cmd>lua require('telescope.builtin').lsp_implementations()<CR>", {desc = "Go to implementations"})
    nnoremap("gr", "<Cmd>lua require('telescope.builtin').lsp_references()<CR>", {desc = "Go to references"})

    nnoremap("<leader>fs", "<Cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>", {desc = "Find document symbol"})
    nnoremap("<leader>fS", "<Cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>", {desc = "Find workspace symbol"})

    nnoremap("<leader>cr", vim.lsp.buf.rename, {desc = "Rename"})
    nnoremap("<leader>ca", vim.lsp.buf.code_action, {desc = "Code action"})

    if cap.documentFormattingProvider then
        nnoremap("<leader>cf", vim.lsp.buf.format, {desc = "Format document"})
    end

    if cap.documentRangeFormattingProvider then
        vnoremap("<leader>cf", vim.lsp.buf.format, {desc = "Format range"})
    end
end

local autocmd = augroup("PeterLspAttach", {clear = true})
autocmd("LspAttach", {callback = on_attach})

require("mason-lspconfig").setup {
    ensure_installed = {"sumneko_lua"},
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
            },
            format = {
                enable = false,
            },
        },
    },
}

local function default_handler(server_name)
    require("lspconfig")[server_name].setup {
        capabilities = capabilities,
        settings = settings[server_name],
    }
end

require("mason-lspconfig").setup_handlers {
    default_handler,
    ["sumneko_lua"] = function(server_name)
        require("lua-dev").setup {
            override = function(root_dir, library)
                -- Add vim plugins and api to path if we are in the chezmoi directory
                local chezmoi_dir = require("peter.chezmoi").source_dir
                if require("lua-dev.util").has_file(chezmoi_dir, root_dir) then
                    library.enabled = true
                    library.plugins = true
                end
            end,
        }

        default_handler(server_name)
    end,
    ["clangd"] = function(server_name)
        require("clangd_extensions").setup {
            server = {
                capabilities = capabilities,
                settings = settings[server_name],
            },
        }
    end,
    -- TODO: rust-tools
}

require("null-ls")
