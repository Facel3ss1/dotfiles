local util = require("peter.util")

-- TODO: Breakpoint icons
-- TODO: Virtual text
-- TODO: mason-nvim-dap?
-- TODO: rust-tools
-- TODO: telescope-dap
-- TODO: one-small-step-for-vimkind
return {
    {
        "mfussenegger/nvim-dap",
        -- stylua: ignore
        keys = {
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
            { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Set conditional breakpoint" },
            { "<leader>dl", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Logpoint message: ")) end, desc = "Set logpoint" },
            { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
            { "<leader>do", function() require("dap").step_over() end, desc = "Step over" },
            { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
            { "<leader>dO", function() require("dap").step_out() end, desc = "Step out" },
            { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
            { "<leader>dr", function() require("dap").repl.open() end, desc = "Repl" },
            { "<leader>ud", function() require("dapui").toggle() end, desc = "Open Dap UI" },
        },
        config = function()
            local dap = require("dap")

            dap.adapters.cppdbg = {
                id = "cppdbg",
                type = "executable",
                command = vim.fn.exepath("OpenDebugAD7"),
            }
            if util.has("win32") then
                dap.adapters.cppdbg.options = {
                    detached = false,
                }
            end

            dap.configurations.cpp = {
                {
                    name = "Launch file (gdb)",
                    type = "cppdbg",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                    cwd = "${workspaceFolder}",
                },
                {
                    name = "Attach to gdb server :1234",
                    type = "cppdbg",
                    request = "launch",
                    MIMode = "gdb",
                    miDebuggerServerAddress = "localhost:1234",
                    miDebuggerPath = vim.fn.exepath("gdb"),
                    cwd = "${workspaceFolder}",
                    program = function()
                        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                },
            }
            dap.configurations.c = dap.configurations.cpp
            dap.configurations.rust = dap.configurations.cpp

            local dapui = require("dapui")
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
        dependencies = {
            {
                "rcarriga/nvim-dap-ui",
                config = function()
                    require("dapui").setup()
                end,
            },
        },
    },
}
