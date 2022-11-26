require("peter.plugins.lsp.handlers")
require("peter.plugins.lsp.diagnostics")

local remap = require("peter.remap")
local augroup = require("peter.au").augroup

local server_on_attach = {
    ["rust_analyzer"] = function(args)
        local rust_tools = require("rust-tools")
        local nnoremap = remap.bind("n", { buffer = args.buf })

        nnoremap("K", rust_tools.hover_actions.hover_actions, { desc = "View docs and hover actions under cursor" })
    end,
}

local function on_attach(args)
    local nnoremap = remap.bind("n", { buffer = args.buf })
    local vnoremap = remap.bind("v", { buffer = args.buf })

    nnoremap("K", vim.lsp.buf.hover, { desc = "View docs under cursor" })
    nnoremap("<C-k>", vim.lsp.buf.signature_help, { desc = "View signature help" })
    nnoremap("gd", vim.lsp.buf.definition, { desc = "Go to definition" })
    nnoremap("gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
    nnoremap(
        "go",
        "<Cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>",
        { desc = "Go to type definition" }
    )
    nnoremap(
        "gI",
        "<Cmd>lua require('telescope.builtin').lsp_implementations()<CR>",
        { desc = "Go to implementations" }
    )
    nnoremap("gr", "<Cmd>lua require('telescope.builtin').lsp_references()<CR>", { desc = "Go to references" })

    nnoremap(
        "<leader>fs",
        "<Cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>",
        { desc = "Find document symbol" }
    )
    nnoremap(
        "<leader>fS",
        "<Cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>",
        { desc = "Find workspace symbol" }
    )

    nnoremap("<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
    nnoremap("<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
    vnoremap("<leader>ca", vim.lsp.buf.code_action, { desc = "Code action (visual)" })

    require("peter.plugins.lsp.formatting").on_attach(args)

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if server_on_attach[client.name] then
        server_on_attach[client.name](args)
    end
end

local autocmd = augroup("PeterLspAttach", { clear = true })
autocmd("LspAttach", { callback = on_attach })

require("mason-lspconfig").setup {
    ensure_installed = { "sumneko_lua" },
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
            workspace = {
                checkThirdParty = false,
            },
        },
    },
    ["rust_analyzer"] = {
        ["rust-analyzer"] = {
            checkOnSave = {
                command = "clippy",
                extraArgs = { "--no-deps" },
            },
        },
    },
}

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local function default_handler(server_name)
    require("lspconfig")[server_name].setup {
        capabilities = capabilities,
        settings = settings[server_name],
    }
end

require("mason-lspconfig").setup_handlers {
    default_handler,
    ["sumneko_lua"] = function(server_name)
        require("neodev").setup {
            override = function(root_dir, library)
                -- Add vim plugins and api to path if we are in the chezmoi directory
                local chezmoi_dir = require("peter.chezmoi").source_dir
                if require("neodev.util").has_file(chezmoi_dir, root_dir) then
                    library.enabled = true
                    library.plugins = true
                end
            end,
        }

        default_handler(server_name)
    end,
    ["rust_analyzer"] = function(server_name)
        require("rust-tools").setup {
            server = {
                capabilities = capabilities,
                settings = settings[server_name],
            },
        }
    end,
    ["clangd"] = function(server_name)
        require("clangd_extensions").setup {
            server = {
                capabilities = capabilities,
                settings = settings[server_name],
            },
        }

        local cmp = require("cmp")

        -- FIXME: clangd completion entries have a space before
        cmp.setup.filetype({ "c", "cpp" }, {
            sorting = {
                comparators = {
                    cmp.config.compare.offset,
                    cmp.config.compare.exact,
                    cmp.config.compare.recently_used,
                    require("clangd_extensions.cmp_scores"),
                    cmp.config.compare.kind,
                    cmp.config.compare.sort_text,
                    cmp.config.compare.length,
                    cmp.config.compare.order,
                },
            },
        })
    end,
}

require("null-ls")
