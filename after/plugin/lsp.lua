local lsp_zero = require('lsp-zero')
-- local util = require('lspconfig.util')

lsp_zero.on_attach(function(_, bufnr)
	local opts = { buffer = bufnr, remap = false }

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
end)

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

local nvim_lsp = require("lspconfig")
nvim_lsp.nixd.setup({
	-- on_attach = on_attach(),
	-- capabilities = capabilities,
	settings = {
		nixd = {
			nixpkgs = {
				expr = "import <nixpkgs> { }",
			},
			formatting = {
				command = { "nixfmt" },
			},
			root_marker = { 'flake.nix', 'default.nix', 'shell.nix' },
			options = {
				nixos = {
					expr =
					'(builtins.getFlake "/home/asergi/dotfiles/nixos").nixosConfigurations.hostname.options',
					},
				},
			},
		},
	}
)




-- lsp config for mojo
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/mojo.lua
-- https://forum.modular.com/t/mojo-lsp-setup-for-neovim/501
-- In order to check installation guide :help lspconfig-all
-- Be sure to have built magic + Mojo, refer to the official guide: https://docs.modular.com/mojo/manual/get-started/
-- require('lspconfig').mojo.setup({
vim.lsp.config("mojo", {
	default_config = {
		cmd = { 'mojo-lsp-server' },
		filetypes = { 'mojo' },
		root_dir = function(fname)
			return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
		end,
		single_file_support = true,
	},
})

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

require('mason').setup({})

require('mason-tool-installer').setup({
	ensure_installed = {
		"prettier",
		"black",
		-- "debugpy",
	}
})
require('mason-lspconfig').setup({
	ensure_installed = { 'vtsls', 'vue_ls', 'bashls', 'rust_analyzer', 'pyright', 'html', 'clangd', 'astro',
		'lua_ls',
		'tailwindcss', 'jsonls', 'dockerls', 'docker_compose_language_service', 'zls', 'markdown_oxide',
		'texlab', 'emmet_language_server', },
	handlers = {
		lsp_zero.default_setup,
		lua_ls = function()
			local lua_opts = lsp_zero.nvim_lua_ls()
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			-- require('lspconfig').lua_ls.setup(lua_opts)
			-- require('lspconfig').lua_ls.setup { options = lua_opts, capabilities = capabilities }
			vim.lsp.config("lua_ls", { options = lua_opts, capabilities = capabilities })
		end,
	},
}) -- If you are using mason.nvim, you can get the ts_plugin_path like this
-- For Mason v1,
-- local mason_registry = require('mason-registry')
-- local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() .. '/node_modules/@vue/language-server'
-- For Mason v2,
-- local vue_language_server_path = vim.fn.expand '$MASON/packages' .. '/vue-language-server' .. '/node_modules/@vue/language-server'
-- or even
-- local vue_language_server_path = vim.fn.stdpath('data');
-- local vue_language_server_path = vim.fs.dirname(vim.fn.exepath("vue-language-server")) ..
-- "/../lib/language-tools/packages/language-server/node_modules/@vue/typescript-plugin"
local vue_language_server_path = vim.fn.stdpath('data') ..
    "/mason/packages/vue-language-server/node_modules/@vue/language-server"
-- IMPORTANT: nvchad users cannot use `$MASON` directly as the option is set to `skip`, see: https://github.com/NvChad/NvChad/blob/29ebe31ea6a4edf351968c76a93285e6e108ea08/lua/nvchad/configs/mason.lua#L4

-- local vue_language_server_path = '/path/to/@vue/language-server'
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
