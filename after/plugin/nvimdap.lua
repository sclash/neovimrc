local dap = require("dap")
local ui = require("dapui")
local dap_virtual_text = require("nvim-dap-virtual-text")

-- Dap Virtual Text
dap_virtual_text.setup()

-- Debug adapters are nix packages (see nixos/programs/nvim-lsp.nix).
-- Replaces mason-nvim-dap.

-- codelldb (C/C++/Rust/Zig): shim script exposed on PATH by nixos/programs/nvim-lsp.nix
dap.adapters.codelldb = {
	type = 'server',
	port = '${port}',
	executable = {
		command = vim.fn.exepath("codelldb"),
		args = { '--port', '${port}' },
	},
}

-- js-debug (JavaScript): nix vscode-js-debug bin wraps `node .../dapDebugServer.js`
dap.adapters["js-debug-adapter"] = {
	type = 'server',
	host = 'localhost',
	port = '${port}',
	executable = {
		command = "js-debug",
		args = { '${port}' },
	},
}

-- python (debugpy): debugpy-adapter shim runs `python -m debugpy.adapter`
dap.adapters.python = function(cb, config)
	if config.request == "attach" then
		local port = (config.connect or config).port
		local host = (config.connect or config).host or "127.0.0.1"
		cb({
			type = "server",
			port = assert(port, "`connect.port` is required for a python `attach` configuration"),
			host = host,
			options = { source_filetype = "python" },
		})
	else
		cb({
			type = "executable",
			command = "debugpy-adapter",
			options = { source_filetype = "python" },
		})
	end
end

-- delve (Go)
dap.adapters.delve = {
	type = 'server',
	port = '${port}',
	executable = {
		command = "dlv",
		args = { 'dap', '-l', '127.0.0.1:${port}' },
	},
}


-- Configurations
dap.configurations = {
	c = {
		{
			name = "Launch file",
			type = "codelldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopAtEntry = false,
		},
	},

	zig = {
		{
			name = "Launch file",
			type = "codelldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopAtEntry = false,
		},
	},

	rust = {
		{
			name = "Launch file",
			type = "codelldb",
			request = "launch",
			program = function()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end,
			cwd = "${workspaceFolder}",
			stopAtEntry = false,
		},
	},

	javascript = {
		{
			name = "Launch",
			type = "js-debug-adapter",
			request = "launch",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			protocol = "inspector",
			console = "integratedTerminal",
		},
		{
			-- For this to work you need to make sure the node process is started with the `--inspect` flag.
			name = "Attach to process",
			type = "js-debug-adapter",
			request = "attach",
			processId = require("dap.utils").pick_process,
		},
	},

	python = {
		{
			-- The first three options are required by nvim-dap
			type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
			request = "launch",
			name = "Launch file",

			-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

			program = "${file}", -- This configuration will launch the current file if used.
			pythonPath = function()
				-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
				-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
				-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
				local cwd = vim.fn.getcwd()
				if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
					return cwd .. "/venv/bin/python"
				elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
					return cwd .. "/.venv/bin/python"
				else
					return "/usr/bin/python"
				end
			end,
		},
	},

	go = {
		{
			type = "delve",
			name = "Debug",
			request = "launch",
			program = "${file}",
		},
		{
			type = "delve",
			name = "Debug test", -- configuration for debugging test files
			request = "launch",
			mode = "test",
			program = "${file}",
		},
		-- works with go.mod packages and sub packages
		{
			type = "delve",
			name = "Debug test (go.mod)",
			request = "launch",
			mode = "test",
			program = "./${relativeFileDirname}",
		},
	},
}

-- Dap UI

ui.setup()

-- vim.fn.sign_define("DapBreakpoint", { text = "🐞" })
vim.fn.sign_define("DapBreakpoint", { text = "🔴" })

dap.listeners.before.attach.dapui_config = function()
	ui.open()
end
dap.listeners.before.launch.dapui_config = function()
	ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	ui.close()
end


-- keymaps DAP
vim.keymap.set("n", "<leader>dt", function() require("dap").toggle_breakpoint() end)
vim.keymap.set("n", "<leader>dc", function() require("dap").continue() end)
vim.keymap.set("n", "<leader>di", function() require("dap").step_into() end)
vim.keymap.set("n", "<leader>do", function() require("dap").step_over() end)
vim.keymap.set("n", "<leader>du", function() require("dap").step_out() end)
vim.keymap.set("n", "<leader>dr", function() require("dap").repl.open() end)
vim.keymap.set("n", "<leader>dl", function() require("dap").run_last() end)
vim.keymap.set("n", "<leader>dq",
	function()
		require("dap").terminate()
		require("dapui").close()
		require("nvim-dap-virtual-text").toggle()
	end)
vim.keymap.set("n", "<leader>db", function() require("dap").list_breakpoints() end)
vim.keymap.set("n", "<leader>de", function() require("dap").set_exception_breakpoints() end)
