local icons = require("peter.util.icons")

-- TODO: Breakpoint icons
-- TODO: mason-nvim-dap?
-- TODO: telescope-dap?
-- TODO: one-small-step-for-vimkind

---@module "lazy"
---@type LazySpec
return {
    {
        "mfussenegger/nvim-dap",
        -- stylua: ignore
        keys = {
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
            {
                "<leader>dB",
                function()
                    vim.ui.input({ prompt = "Breakpoint condition: " }, function(input)
                        require("dap").set_breakpoint(input)
                    end)
                end,
                desc = "Set conditional breakpoint",
            },
            {
                "<leader>dl",
                function()
                    vim.ui.input({ prompt = "Logpoint message: " }, function(input)
                        require("dap").set_breakpoint(nil, nil, input)
                    end)
                end,
                desc = "Set logpoint",
            },

            { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
            { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to cursor" },
            { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },

            { "<leader>do", function() require("dap").step_over() end, desc = "Step over" },
            { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
            { "<leader>dO", function() require("dap").step_out() end, desc = "Step out" },
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end
        end,
        dependencies = {
            {
                "rcarriga/nvim-dap-ui",
                -- stylua: ignore
                keys = {
                    ---@diagnostic disable-next-line: missing-fields
                    { "<leader>de", function() require("dapui").eval(nil, { enter = true }) end, mode = { "n", "v" }, desc = "Evaluate expression" },
                    { "<leader>ud", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
                },
                opts = {
                    icons = {
                        collapsed = icons.ui.collapsed,
                        expanded = icons.ui.expanded,
                        current_frame = icons.arrows.right,
                    },
                    floating = { border = "rounded" },
                },
                dependencies = {
                    "nvim-neotest/nvim-nio",
                },
            },
            {
                "theHamsta/nvim-dap-virtual-text",
                config = true,
            },
            "williamboman/mason.nvim",
        },
    },
}
