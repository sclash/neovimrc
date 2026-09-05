local is_nixos = require("asergi.platform").is_nixos;

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("asergi-lsp-attach", { clear = true }),
	callback = function(event)
		local opts = { buffer = event.buf, remap = false }

		vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
		vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
		vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
		vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
		-- vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
		-- vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
		vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)
		vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)
		vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
		vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
		vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
		vim.keymap.set("n", "<leader>h", function() vim.lsp.buf.signature_help() end, opts)
	end,
})

-- to learn how to use mason.nvim with lsp-zero
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
--
--

-- vim.lsp.enable("nixd")
-- vim.lsp.config("nixd", {
-- 	default_config = {
-- 		cmd = { 'nixd' },
-- 		filetypes = { 'nix' },
-- 		root_dir = { 'flake.nix', 'default.nix', 'shell.nix' },
-- 	},
-- 	settings = {
-- 		nixd = {
-- 			nixpkgs = {
-- 				expr = "import <nixpkgs> { }",
-- 			},
-- 			formatting = {
-- 				-- choose: "nixfmt", "alejandra", "nixfmt-rfc-style"
-- 				command = { "nixfmt" },
-- 			},
-- 		},
-- 	},
-- })

local clangd_cmd = {
	"clangd",
	"--background-index",
	"--clang-tidy",
}
local clang_cmd_fallbackFlags = {
	"-std=c11",
}

local function nix_eval(attr)
	local handle = io.popen("nix eval --raw nixpkgs#" .. attr .. " 2>/dev/null")
	if not handle then return nil end
	local result = handle:read("*a")
	handle:close()
	result = vim.trim(result)
	if result == "" then return nil end
	return result
end

local function nix_include(attr)
	local path = nix_eval(attr)
	if not path then return nil end
	return path .. "/include"
end
--
-- local function nix_qml_path(attr)
-- 	local p = nix_eval(attr)
-- 	if p and p ~= "" then
-- 		p = p:gsub("%s+$", "")
-- 		local candidate = p .. "/lib/qt-6/qml"
-- 		-- nix eval for quickshell returns source path without qml; verify existence
-- 		if vim.loop.fs_stat(candidate) then
-- 			return candidate
-- 		end
-- 	end
-- end
--
-- local quickshell_qml = nix_qml_path("quickshell")
-- local qt_qml = nix_qml_path("qt6.qtdeclarative")
-- -- fallback to home-manager aggregated qml path (contains both QtQuick + Quickshell)
local hm_qml = "/etc/profiles/per-user/asergi/lib/qt-6/qml"
-- if not quickshell_qml or not vim.loop.fs_stat(quickshell_qml) then
-- 	quickshell_qml = hm_qml
-- end
-- if not qt_qml or not vim.loop.fs_stat(qt_qml) then
-- 	qt_qml = hm_qml
-- end
-- local qmlls_cmd = { "/etc/profiles/per-user/asergi/bin/qmlls", "-E" }
-- if quickshell_qml and vim.loop.fs_stat(quickshell_qml) then
-- 	vim.list_extend(qmlls_cmd, { "-I", quickshell_qml })
-- end
-- if qt_qml and qt_qml ~= quickshell_qml and vim.loop.fs_stat(qt_qml) then
-- 	vim.list_extend(qmlls_cmd, { "-I", qt_qml })
-- end
-- -- deduplicate if both resolve to same aggregated path
-- if #qmlls_cmd == 2 then -- no -I added, fallback ensures at least hm_qml
-- 	vim.list_extend(qmlls_cmd, { "-I", hm_qml })
-- end
vim.lsp.config("qmlls", {
	-- cmd = qmlls_cmd,
	cmd = {"qmlls", "-E", "-I", hm_qml},
	-- cmd = { "qmlls", "-E" },
	filetypes = { "qml", "qmljs" },
	root_markers = { ".git", "shell.qml" },
})
vim.lsp.enable("qmlls")

-- Optimized: cache nix includes to avoid blocking startup (nix eval is ~1-2s)
local cache_path = vim.fn.stdpath("cache") .. "/nix-clangd-includes.json"
local cache_ttl = 7 * 24 * 60 * 60 -- 7 days

local function load_nix_includes_cache()
	if not is_nixos then return nil end
	local fd = io.open(cache_path, "r")
	if not fd then return nil end
	local content = fd:read("*a")
	fd:close()
	local ok, data = pcall(vim.json.decode, content)
	if not ok or type(data) ~= "table" then return nil end
	if not data.glibc or not data.gcc or not data.timestamp then return nil end
	if os.time() - data.timestamp > cache_ttl then return nil end
	if not vim.uv.fs_stat(data.glibc) then return nil end
	return data
end

local function save_nix_includes_cache(glibc, gcc)
	local dir = vim.fn.fnamemodify(cache_path, ":h")
	vim.fn.mkdir(dir, "p")
	local data = { glibc = glibc, gcc = gcc, timestamp = os.time() }
	local fd = io.open(cache_path, "w")
	if fd then
		fd:write(vim.json.encode(data))
		fd:close()
	end
end

local function apply_fallback_flags(glibc, gcc)
	if not glibc or not gcc then return end
	for _, v in ipairs(clang_cmd_fallbackFlags) do
		if v == glibc or v == gcc then return end
	end
	table.insert(clang_cmd_fallbackFlags, "-isystem")
	table.insert(clang_cmd_fallbackFlags, glibc)
	table.insert(clang_cmd_fallbackFlags, "-isystem")
	table.insert(clang_cmd_fallbackFlags, gcc)
	vim.lsp.config("clangd", {
		cmd = clangd_cmd,
		init_options = { fallbackFlags = clang_cmd_fallbackFlags },
	})
end

local function refresh_nix_includes_async()
	if not is_nixos then return end
	if vim.fn.executable("nix") == 0 then return end
	local pending = 2
	local results = {}
	local function check_done()
		pending = pending - 1
		if pending ~= 0 then return end
		local glibc_path = results.glibc and vim.trim(results.glibc) or nil
		local gcc_path = results.gcc and vim.trim(results.gcc) or nil
		if not glibc_path or glibc_path == "" or not gcc_path or gcc_path == "" then return end
		local glibc = glibc_path .. "/include"
		local gcc = gcc_path .. "/include"
		if not vim.uv.fs_stat(glibc) then return end
		save_nix_includes_cache(glibc, gcc)
		vim.schedule(function()
			apply_fallback_flags(glibc, gcc)
		end)
	end
	vim.system({ "nix", "eval", "--raw", "nixpkgs#glibc.dev" }, { text = true }, function(obj)
		results.glibc = (obj.code == 0 and obj.stdout) or nil
		vim.schedule(check_done)
	end)
	vim.system({ "nix", "eval", "--raw", "nixpkgs#gcc.cc.lib" }, { text = true }, function(obj)
		results.gcc = (obj.code == 0 and obj.stdout) or nil
		vim.schedule(check_done)
	end)
end

if is_nixos then
	local cached = load_nix_includes_cache()
	if cached then
		apply_fallback_flags(cached.glibc, cached.gcc)
	end
	vim.schedule(function()
		vim.defer_fn(refresh_nix_includes_async, 200)
	end)
end

vim.lsp.config("clangd", {
	cmd = clangd_cmd,
	init_options = {
		fallbackFlags = clang_cmd_fallbackFlags,
	},
})
vim.lsp.enable("clangd")

vim.api.nvim_create_user_command("NixClangdRefresh", function()
	vim.fn.delete(cache_path)
	refresh_nix_includes_async()
	vim.notify("nix clangd includes refresh started (async)", vim.log.levels.INFO)
end, { desc = "Refresh cached nix glibc/gcc includes for clangd" })
--
--
vim.lsp.config("nixd", {
	cmd = { "nixd" },
	filetypes = { "nix" },
	root_markers = { "flake.nix", ".git" },
	settings = {
		nixd = {
			nixpkgs = {
				expr = "import <nixpkgs> { }",
			},
			formatting = {
				command = { "nixfmt" },
			},
			options = {
				nixos = {
					expr =
					'(builtins.getFlake "/home/asergi/dotfiles/nixos").nixosConfigurations.nixos-os.options',
				},
				home_manager = {
					expr =
					'(builtins.getFlake "/home/asergi/dotfiles/nixos").homeConfigurations."asergi@nixos-os".options',
				},
				flake_parts = {
					expr =
					'let flake = builtins.getFlake ("/home/asergi/dotfiles/nixos"); in flake.debug.options // flake.currentSystem.options',
				},
			},
		},
	},
})
vim.lsp.enable("nixd")


-- nvim_lsp.nixd.setup({
-- 	-- on_attach = on_attach(),
-- 	-- capabilities = capabilities,
-- 	settings = {
-- 		nixd = {
-- 			flake = {
-- 				enable = true,
-- 				autoArchive = false,
-- 			},
-- 			nixpkgs = {
-- 				expr = "import <nixpkgs> { }",
-- 			},
-- 			formatting = {
-- 				command = { "nixfmt" },
-- 			},
-- 			root_marker = { 'flake.nix', 'default.nix', 'shell.nix' },
-- 			options = {
-- 				nixos = {
-- 					-- THIS WORKS
-- 					expr =
-- 					'(builtins.getFlake "/home/asergi/dotfiles/nixos").nixosConfigurations.nixos-os.options',
-- 					--
-- 					-- expr = '(builtins.getFlake ("git+file://" + toString  github:sclash/dotfiles?ref=home-manager/nixos)).nixosConfigurations.nixos-os.options',
-- 					-- expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.nixos-os.options',
-- 				},
-- 				home_manager = {
-- 					expr =
-- 					'(builtins.getFlake "/home/asergi/dotfiles/nixos").homeConfigurations."asergi@nixos-os".options',
-- 					-- expr = '(builtins.getFlake ("git+file://" + toString  github:sclash/dotfiles?ref=home-manager/nixos)).homeConfigurations."asergi@nixos-os".options',
-- 					-- expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."asergi@nixos-os".options',
-- 				},
-- 				flake_parts = {
-- 					expr =
-- 					'let flake = builtins.getFlake ("/home/asergi/dotfiles/nixos"); in flake.debug.options // flake.currentSystem.options',
-- 				},
-- 			},
-- 		},
-- 	},
-- }
-- )




-- lsp config for mojo
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/mojo.lua
-- https://forum.modular.com/t/mojo-lsp-setup-for-neovim/501
-- In order to check installation guide :help lspconfig-all
-- Be sure to have built magic + Mojo, refer to the official guide: https://docs.modular.com/mojo/manual/get-started/
-- uv init
-- uv add "max[all]" (to install mojo-lsp-server)
-- require('lspconfig').mojo.setup({
--  DEPRECATED https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/mojo.lua
-- vim.lsp.config("mojo", {
-- 	default_config = {
-- 		cmd = { 'mojo-lsp-server' },
-- 		filetypes = { 'mojo' },
-- 		root_dir = function(fname)
-- 			return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
-- 		end,
-- 		single_file_support = true,
-- 	},
-- })
--
--  NEW https://github.com/neovim/nvim-lspconfig/blob/master/lsp/mojo.lua
---@type vim.lsp.Config
vim.lsp.config("mojo", {
	cmd = { 'mojo-lsp-server' },
	filetypes = { 'mojo' },
	root_markers = { '.git' },
})
vim.lsp.enable("mojo")

-- require('lspconfig').vuels.setup({
-- 	default_config = {
-- 		filetypes = {'vue'},
-- 	}
-- })


vim.lsp.config("emmet_language_server", {
	filetypes = { "html" },
})

-- require("lspconfig").emmet_language_server.setup({
-- 	filetypes = { "typescript", "javascript", "vue" },
-- })
--
-- require("lspconfig").html.setup({
-- 	filetypes = { "typescript", "javascript", "vue", "html" },
-- })

-- require("lspconfig").htmx.setup({
-- 	filetypes = { "typescript", "javascript", "vue", "html" },
--
-- })
-- require("lspconfig").volar.setup {
-- 	-- add filetypes for typescript, javascript and vue
-- 	filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
-- 	init_options = {
-- 		vue = {
-- 			-- disable hybrid mode
-- 			hybridMode = false,
-- 		},
-- 	},
-- }

-- require("lspconfig").volar.setup({
-- 	init_options = {
-- 		vue = {
-- 			hybridMode = false,
-- 		},
-- 	},
-- 	settings = {
-- 		typescript = {
-- 			inlayHints = {
-- 				enumMemberValues = {
-- 					enabled = true,
-- 				},
-- 				functionLikeReturnTypes = {
-- 					enabled = true,
-- 				},
-- 				propertyDeclarationTypes = {
-- 					enabled = true,
-- 				},
-- 				parameterTypes = {
-- 					enabled = true,
-- 					suppressWhenArgumentMatchesName = true,
-- 				},
-- 				variableTypes = {
-- 					enabled = true,
-- 				},
-- 			},
-- 		},
-- 	},
-- 	filetypes = { "vue" },
-- 	languages = { "vue" },
-- })

-- require('lspconfig').ts_ls.setup({
-- 	init_options = {
-- 		plugins = {
-- 			{
-- 				name = "@vue/typescript-plugin",
-- 				location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
-- 				languages = { "javascript", "typescript", "vue" },
-- 			},
-- 		},
-- 	},
-- 	filetypes = {
-- 		"javascript",
-- 		"typescript",
-- 		"vue",
-- 	},
-- })

-- vim.lsp.config("ts_ls", {
-- 	init_options = {
-- 		plugins = {
-- 			{
-- 				name = '@vue/typescript-plugin',
-- 				location = vim.fn.stdpath 'data' ..
-- 				    '/mason/packages/vue-language-server/node_modules/@vue/language-server',
-- 				languages = { 'vue' },
-- 			},
-- 		},
-- 	},
-- 	settings = {
-- 		typescript = {
-- 			tsserver = {
-- 				useSyntaxServer = false,
-- 			},
-- 			inlayHints = {
-- 				includeInlayParameterNameHints = 'all',
-- 				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
-- 				includeInlayFunctionParameterTypeHints = true,
-- 				includeInlayVariableTypeHints = true,
-- 				includeInlayVariableTypeHintsWhenTypeMatchesName = true,
-- 				includeInlayPropertyDeclarationTypeHints = true,
-- 				includeInlayFunctionLikeReturnTypeHints = true,
-- 				includeInlayEnumMemberValueHints = true,
-- 			},
-- 		},
-- 	},
-- })

-- require('lspconfig').html.setup {
-- 	filetypes = { 'html',  'vue' },
-- }

-- LSP capabilities come from blink.cmp (replaces the lsp-zero / mason-lspconfig wiring)
vim.lsp.config('*', {
	capabilities = require('blink.cmp').get_lsp_capabilities(nil, true),
})

-- lua_ls: native replacement for lsp_zero.nvim_lua_ls()
vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			telemetry = { enable = false },
			runtime = {
				version = 'LuaJIT',
				path = vim.list_extend(vim.split(package.path, ';'), { 'lua/?.lua', 'lua/?/init.lua' }),
			},
			diagnostics = { globals = { 'vim' } },
			workspace = {
				checkThirdParty = false,
				library = {
					vim.fn.expand('$VIMRUNTIME/lua'),
					vim.fn.stdpath('config') .. '/lua',
				},
			},
		},
	},
})

-- Servers previously installed by mason-lspconfig are now nix packages
-- (see nixos/programs/nvim-lsp.nix). clangd, qmlls, nixd and mojo are
-- enabled above; vtsls and vue_ls are enabled at the bottom of this file.
vim.lsp.enable({
	'bashls', 'rust_analyzer', 'pyright', 'html', 'astro', 'lua_ls',
	'tailwindcss', 'jsonls', 'dockerls', 'docker_compose_language_service',
	'zls', 'markdown_oxide', 'texlab', 'emmet_language_server', 'gopls',
})

-- @vue/typescript-plugin location: resolve it from the nix vue-language-server
-- package (nix layout: <store>/lib/language-tools/packages/typescript-plugin)
local function vue_typescript_plugin_path()
	local exe = vim.fn.exepath('vue-language-server')
	if exe == '' then return nil end
	local dir = vim.fs.dirname(vim.uv.fs_realpath(exe) or exe)
	for _ = 1, 8 do
		if not dir or dir == '/' or dir == '' then return nil end
		for _, candidate in ipairs({
			dir .. '/lib/language-tools/packages/typescript-plugin',
			dir .. '/packages/typescript-plugin',
		}) do
			if vim.uv.fs_stat(candidate) then return candidate end
		end
		dir = vim.fs.dirname(dir)
	end
	return nil
end

local vue_language_server_path = vue_typescript_plugin_path()
if not vue_language_server_path then
	-- fallback: legacy mason install path (only used while the mason data dir still exists)
	vue_language_server_path = vim.fn.stdpath('data') ..
		"/mason/packages/vue-language-server/node_modules/@vue/language-server"
	vim.notify("vue-language-server not found on PATH: using mason fallback for @vue/typescript-plugin", vim.log.levels.WARN)
end
local tsserver_filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', }
local vue_plugin = {
	name = '@vue/typescript-plugin',
	location = vue_language_server_path,
	languages = { 'vue' },
	configNamespace = 'typescript',
}
local vtsls_config = {
	settings = {
		vtsls = {
			tsserver = {
				globalPlugins = {
					vue_plugin,
				},
			},
		},
	},
	filetypes = tsserver_filetypes,
}

-- local ts_ls_config = {
-- 	init_options = {
-- 		plugins = {
-- 			vue_plugin,
-- 		},
-- 	},
-- 	filetypes = tsserver_filetypes,
-- }

-- If you are on most recent `nvim-lspconfig`
local vue_ls_config = {}

-- If you are not on most recent `nvim-lspconfig` or you want to override
-- local vue_ls_config = {
-- 	on_init = function(client)
-- 		client.handlers['tsserver/request'] = function(_, result, context)
-- 			local ts_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'ts_ls' })
-- 			local vtsls_clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
-- 			local clients = {}
--
-- 			vim.list_extend(clients, ts_clients)
-- 			vim.list_extend(clients, vtsls_clients)
--
-- 			if #clients == 0 then
-- 				vim.notify(
-- 				'Could not find `vtsls` or `ts_ls` lsp client, `vue_ls` would not work without it.',
-- 					vim.log.levels.ERROR)
-- 				return
-- 			end
-- 			local ts_client = clients[1]
--
-- 			local param = unpack(result)
-- 			local id, command, payload = unpack(param)
-- 			ts_client:exec_cmd({
-- 				title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
-- 				command = 'typescript.tsserverRequest',
-- 				arguments = {
-- 					command,
-- 					payload,
-- 				},
-- 			}, { bufnr = context.bufnr }, function(_, r)
-- 				local response = r and r.body
-- 				-- TODO: handle error or response nil here, e.g. logging
-- 				-- NOTE: Do NOT return if there's an error or no response, just return nil back to the vue_ls to prevent memory leak
-- 				local response_data = { { id, response } }
--
-- 				---@diagnostic disable-next-line: param-type-mismatch
-- 				client:notify('tsserver/response', response_data)
-- 			end)
-- 		end
-- 	end,
-- }
-- nvim 0.11 or above
vim.lsp.config('vtsls', vtsls_config)
vim.lsp.config('vue_ls', vue_ls_config)
-- vim.lsp.config('ts_ls', ts_ls_config)
-- vim.lsp.enable({  'vue_ls', 'ts_ls',  }) -- If using `ts_ls` replace `vtsls` to `ts_ls`
vim.lsp.enable({ 'vue_ls', 'vtsls', }) -- If using `ts_ls` replace `vtsls` to `ts_ls`
