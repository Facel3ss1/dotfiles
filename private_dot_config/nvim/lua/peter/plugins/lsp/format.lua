local M = {}

local null_ls = require("null-ls")

M.should_format_on_save = true

local function toggle_format_on_save()
    M.should_format_on_save = not M.should_format_on_save

    if M.should_format_on_save then
        vim.notify("Enabled format on save", vim.log.levels.INFO, { title = "Formatting" })
    else
        vim.notify("Disabled format on save", vim.log.levels.INFO, { title = "Formatting" })
    end
end

vim.keymap.set("n", "<leader>tf", toggle_format_on_save, { desc = "Toggle format on save" })

local function null_ls_has_method(filetype, method)
    local sources = null_ls.get_sources()
    for _, source in ipairs(sources) do
        if source.filetypes[filetype] and source.methods[method] then
            return true
        end
    end

    return false
end

-- Called from the LspAttach autocommand
function M.on_attach(client, buf)
    local capabilities = client.server_capabilities
    local filetype = vim.bo[buf].filetype

    if null_ls_has_method(filetype, null_ls.methods.FORMATTING) then
        -- If null-ls can format this filetype, disable formatting on the other client
        capabilities.documentFormattingProvider = client.name == "null-ls"
        capabilities.documentRangeFormattingProvider = client.name == "null-ls"
            and null_ls_has_method(filetype, null_ls.methods.RANGE_FORMATTING)
    else
        -- Otherwise, only enable if the regular client can format
        capabilities.documentFormattingProvider = not (client.name == "null-ls")
            and capabilities.documentFormattingProvider
        capabilities.documentRangeFormattingProvider = not (client.name == "null-ls")
            and capabilities.documentRangeFormattingProvider
    end

    if capabilities.documentFormattingProvider then
        -- Note that we don't clear the autogroup when we attach to a new buffer
        local format_group = vim.api.nvim_create_augroup("PeterLspFormatOnSave", { clear = false })
        -- Ensure that there is exactly one formatting autocommand per buffer
        if #vim.api.nvim_get_autocmds { group = format_group, buffer = buf } == 0 then
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = format_group,
                buffer = buf,
                callback = function()
                    if M.should_format_on_save then
                        vim.lsp.buf.format()
                    end
                end,
                desc = "Call vim.lsp.buf.format() if format on save is enabled",
            })
        end
    end

    -- Use internal formatting instead of `vim.lsp.formatexpr()` so that gq works
    -- See https://github.com/neovim/neovim/pull/19677
    vim.bo[buf].formatexpr = nil
end

return M
