local util = require("peter.util")

-- Space is the leader key, so remove the default behaviour
vim.keymap.set("n", "<Space>", "<Nop>")

-- Make j and k take line wrapping into account
-- If we supply a count beforehand, use default behaviour
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Bri'ish version of # key
vim.keymap.set("n", "£", "#")

-- Make <Esc> clear search highlights
vim.keymap.set("n", "<Esc>", "<Cmd>nohl<CR>")

vim.keymap.set({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

vim.keymap.set("n", "<A-j>", ":.m .+1<CR>==", { desc = "Move line up", silent = true })
vim.keymap.set("n", "<A-k>", ":.m .-2<CR>==", { desc = "Move line down", silent = true })
vim.keymap.set("x", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move line up", silent = true })
vim.keymap.set("x", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move line down", silent = true })
vim.keymap.set("i", "<A-j>", "<Esc>:.m .+1<CR>==gi", { desc = "Move line up", silent = true })
vim.keymap.set("i", "<A-k>", "<Esc>:.m .-2<CR>==gi", { desc = "Move line down", silent = true })

-- Backspace in select mode changes instead of deletes
vim.keymap.set("s", "<BS>", "<C-g>c")

-- Repeatable indenting
vim.keymap.set("x", ">", ">gv")
vim.keymap.set("x", "<", "<gv")

-- Recenter screen after certain movements
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Snippet jumping
vim.keymap.set({ "i", "s" }, "<Tab>", function()
    if vim.snippet.active { direction = 1 } then
        vim.schedule(function()
            vim.snippet.jump(1)
        end)
        return
    end

    return "<Tab>"
end, { expr = true, silent = true })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
    if vim.snippet.active { direction = -1 } then
        vim.schedule(function()
            vim.snippet.jump(-1)
        end)
        return
    end

    return "<S-Tab>"
end, { expr = true, silent = true })

vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line diagnostics" })

vim.keymap.set("n", "<leader>uc", function()
    -- TODO: Delete all the buffers when we close the tab (mini.bufremove)?
    vim.cmd.tabnew()
    vim.cmd.tcd { require("peter.config.chezmoi").source_dir }
end, { desc = "Open chezmoi directory in new tab" })
vim.keymap.set("n", "<leader>ul", "<Cmd>Lazy<CR>", { desc = "Open Lazy" })

vim.keymap.set("n", "<leader>hi", "<Cmd>Inspect<CR>", { desc = "Inspect at cursor" })
vim.keymap.set("n", "<leader>ht", "<Cmd>InspectTree<CR>", { desc = "Treesitter syntax tree" })

-- stylua: ignore start
vim.keymap.set("n", "<leader>tw", function() util.toggle("wrap") end, { desc = "Toggle word wrap" })
vim.keymap.set("n", "<leader>ts", function() util.toggle("spell") end, { desc = "Toggle spell checking" })
-- stylua: ignore end

vim.keymap.set("n", "<leader>td", function()
    local diagnostics_enabled = vim.diagnostic.is_enabled()
    diagnostics_enabled = not diagnostics_enabled

    vim.diagnostic.enable(diagnostics_enabled)

    if diagnostics_enabled then
        util.info("Enabled diagnostics", { title = "Diagnostics" })
    else
        util.info("Disabled diagnostics", { title = "Diagnostics" })
    end
end, { desc = "Toggle diagnostics" })

-- TODO: dd in quickfix list (quickfix reflector)
