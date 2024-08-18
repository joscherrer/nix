return {
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            require('dapui').setup()
            local dap, dapui = require('dap'), require('dapui')
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
            vim.keymap.set('n', '<leader>dt', function() require("dapui").toggle() end, { desc = "DAP: Toggle UI" })
            vim.keymap.set('n', '<F9>', function() require("dap").toggle_breakpoint() end,
                { desc = "DAP: Toggle breakpoint" })
            vim.keymap.set('n', '<F5>', function() require("dap").continue() end, { desc = "DAP: Continue" })
            vim.keymap.set('n', '<F10>', function() require("dap").step_over() end, { desc = "DAP: Step over" })
            vim.keymap.set('n', '<F11>', function() require("dap").step_into() end, { desc = "DAP: Step into" })
            vim.keymap.set('n', '<S-F11>', function() require("dap").step_out() end, { desc = "DAP: Step out" })
            vim.keymap.set('n', '<F12>', function() require("dap").terminate() end, { desc = "DAP: Terminate" })
        end
    },
    {
        "mfussenegger/nvim-dap-python",
        config = function()
            require('dap-python').setup('python3')
        end
    },
    {
        "leoluz/nvim-dap-go",
        opts = {}
    }
}
