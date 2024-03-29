local M = {}

local util = require("peter.util")

M.source_dir = vim.fs.normalize("~/.local/share/chezmoi")

-- TODO: Keymap to jump to target path file
-- TODO: Use vim.filetype.add() to register filetypes

local function chezmoi_command(command, success_message)
    table.insert(command, 1, "chezmoi")
    vim.fn.jobstart(command, {
        stderr_buffered = true,
        on_exit = function(_, exit_code, _)
            if exit_code == 0 then
                util.info(success_message, { title = "chezmoi" })
            end
        end,
        on_stderr = function(_, lines, _)
            -- The last line is always an empty string, remove it
            table.remove(lines)
            if #lines > 0 then
                util.warn(table.concat(lines, "\n"), { title = "chezmoi" })
            end
        end,
    })
end

vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("ChezmoiApplyOnSave", { clear = true }),
    pattern = M.source_dir .. "/*",
    callback = function(opts)
        -- TODO: Exclude certain filetypes?
        -- TODO: Somehow check the output of `chezmoi ignored`? Seems difficult
        -- NOTE: See https://github.com/alker0/chezmoi.vim

        -- The absolute path of the current buffer
        local absolute_path = opts.match
        -- Ignore paths that are in the .git folder
        -- Note that we need to escape the dots in the path
        local git_folder_pattern = M.source_dir:gsub("%.", "%%.") .. "/%.git/.*"
        if absolute_path:match(git_folder_pattern) then
            return
        end

        local relative_path = vim.fn.expand("%")
        chezmoi_command({ "apply", "--source-path", relative_path }, "chezmoi apply: " .. relative_path)
    end,
    desc = "Run chezmoi apply",
})

-- This only works in WSL, and I primarily change the config in WSL anyway
if not util.has("win32") then
    vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("ChezmoiAddLazyLock", { clear = true }),
        pattern = "LazyUpdate",
        callback = function()
            -- TODO: Make a git commit?
            local lockfile = vim.fs.normalize(vim.fn.stdpath("config")) .. "/lazy-lock.json"
            chezmoi_command({ "add", lockfile }, "chezmoi add: lazy-lock.json")
        end,
        desc = "Run chezmoi add lazy-lock.json",
    })
end

return M
