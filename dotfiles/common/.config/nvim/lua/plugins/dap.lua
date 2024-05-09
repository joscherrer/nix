return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
        "jay-babu/mason-nvim-dap.nvim"
    },
    config = function()
        require('mason').setup()
        require('mason-nvim-dap').setup()
        require('dapui').setup()
    end
}
