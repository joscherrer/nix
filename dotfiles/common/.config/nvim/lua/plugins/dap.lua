local delve_config = {
    type = "server",
    port = "${port}",
    executable = {
        command = "dlv",
        args = { "dap", "-l", "127.0.0.1:${port}" },
        detached = true,
        cwd = nil,
    },
    options = {
        initialize_timeout_sec = 20,
    },
    build_flags = "",
    output_mode = "remote",
}

local function filtered_pick_process()
    local opts = {}
    vim.ui.input(
        { prompt = "Search by process name (lua pattern), or hit enter to select from the process list: " },
        function(input)
            opts["filter"] = input or ""
        end
    )
    return require("dap.utils").pick_process(opts)
end

local function get_arguments()
    return coroutine.create(function(dap_run_co)
        local args = {}
        vim.ui.input({ prompt = "Args: " }, function(input)
            args = vim.split(input or "", " ")
            coroutine.resume(dap_run_co, args)
        end)
    end)
end

local function get_build_flags(config)
    return coroutine.create(function(dap_run_co)
        local build_flags = config.build_flags
        vim.ui.input({ prompt = "Build Flags: " }, function(input)
            build_flags = vim.split(input or "", " ")
            coroutine.resume(dap_run_co, build_flags)
        end)
    end)
end

return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require('dap')
            dap.adapters.jsonnet = {
                type = 'executable',
                command = vim.fn.expand("~/go/bin/jsonnet-debugger"),
                args = { '-s', '-d', '-J', 'vendor', '-J', 'lib' },
            }
            dap.adapters.go = function(callback, client_config)
                if client_config.port == nil then
                    callback(delve_config)
                    return
                end

                local host = client_config.host
                if host == nil then
                    host = "127.0.0.1"
                end

                local listener_addr = host .. ":" .. client_config.port
                delve_config.port = client_config.port
                delve_config.executable.args = { "dap", "-l", listener_addr }

                callback(delve_config)
            end
            dap.configurations.jsonnet = {
                {
                    type = 'jsonnet',
                    request = 'launch',
                    name = 'debug',
                    program = '${file}',
                }
            }

            dap.configurations.go = {
                {
                    type = "go",
                    name = "Debug",
                    request = "launch",
                    program = "${file}",
                    buildFlags = delve_config.build_flags,
                    outputMode = delve_config.output_mode,
                },
                {
                    type = "go",
                    name = "Debug (Arguments)",
                    request = "launch",
                    program = "${file}",
                    args = get_arguments,
                    buildFlags = delve_config.build_flags,
                    outputMode = delve_config.output_mode,
                },
                {
                    type = "go",
                    name = "Debug (Arguments & Build Flags)",
                    request = "launch",
                    program = "${file}",
                    args = get_arguments,
                    buildFlags = get_build_flags,
                    outputMode = delve_config.output_mode,
                },
                {
                    type = "go",
                    name = "Debug Package",
                    request = "launch",
                    program = "${fileDirname}",
                    buildFlags = delve_config.build_flags,
                    outputMode = delve_config.output_mode,
                },
                {
                    type = "go",
                    name = "Attach",
                    mode = "local",
                    request = "attach",
                    processId = filtered_pick_process,
                    buildFlags = delve_config.build_flags,
                },
                {
                    type = "go",
                    name = "Debug test",
                    request = "launch",
                    mode = "test",
                    program = "${file}",
                    buildFlags = delve_config.build_flags,
                    outputMode = delve_config.output_mode,
                },
                {
                    type = "go",
                    name = "Debug test (go.mod)",
                    request = "launch",
                    mode = "test",
                    program = "./${relativeFileDirname}",
                    buildFlags = delve_config.build_flags,
                    outputMode = delve_config.output_mode,
                },
            }
        end,
    },
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
    -- {
    --     "leoluz/nvim-dap-go",
    --     opts = {}
    --     -- config = function()
    --     --     require('dap-go').setup({
    --     --         dap_configurations = {
    --     --             {
    --     --                 type = 'go',
    --     --                 name = 'Debug avatar-manager',
    --     --                 request = 'launch',
    --     --                 program = '${workspaceFolder}/cmd/manager',
    --     --             },
    --     --         },
    --     --     })
    --     -- end
    -- }
}
