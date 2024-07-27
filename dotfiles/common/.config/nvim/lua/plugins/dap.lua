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
      vim.keymap.set('n', '<leader>dt', function() require("dapui").toggle() end, {})
      vim.keymap.set('n', '<F9>', function() require("dap").toggle_breakpoint() end, {})
      vim.keymap.set('n', '<F5>', function() require("dap").continue() end, {})
      vim.keymap.set('n', '<F10>', function() require("dap").step_over() end, {})
      vim.keymap.set('n', '<F11>', function() require("dap").step_into() end, {})
    end
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function()
      require('dap-python').setup('python3')
    end
  }
}
