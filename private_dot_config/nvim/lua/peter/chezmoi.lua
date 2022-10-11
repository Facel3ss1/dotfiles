local M = {}

local augroup = require("peter.au").augroup

M.source_dir = vim.fn.expand("~") .. "/.local/share/chezmoi"

local autocmd = augroup("ChezmoiApplyOnSave", {clear = true})
autocmd("BufWritePost", {
    pattern = M.source_dir .. "/*",
    callback = function(opts)
        -- TODO: Exclude certain filetypes?
        -- TODO: Somehow check the output of `chezmoi ignored`? Seems difficult
        -- NOTE: See https://github.com/alker0/chezmoi.vim

        -- The absolute path of the current buffer
        local absolute_path = opts.match
        -- Ignore paths that are in the .git folder (we need to escape dots in the path)
        local git_folder_pattern = M.source_dir:gsub("%.", "%%.") .. "/%.git/.*"
        if absolute_path:match(git_folder_pattern) then
            return
        end

        local function chezmoi_info(message)
            vim.notify(message, vim.log.levels.INFO, {title = "chezmoi"})
        end

        local function chezmoi_warn(message)
            vim.notify(message, vim.log.levels.WARN, {title = "chezmoi"})
        end

        local relative_path = vim.fn.expand("%")
        vim.fn.jobstart({"chezmoi", "apply", "--source-path", relative_path}, {
            stderr_buffered = true,
            on_exit = function(_, exit_code, _)
                if exit_code == 0 then
                    chezmoi_info("chezmoi apply: " .. relative_path)
                end
            end,
            on_stderr = function(_, lines, _)
                -- The last line is always an empty string, remove it
                table.remove(lines)
                if #lines > 0 then
                    chezmoi_warn(table.concat(lines, "\n"))
                end
            end,
        })
    end,
})

return M
