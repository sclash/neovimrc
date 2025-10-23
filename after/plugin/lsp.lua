local lsp_zero = require('lsp-zero')
local util = require('lspconfig.util')

lsp_zero.on_attach(function(client, bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
	vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
	vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
	vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
	vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
	vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
	vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
	vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
	vim.keymap.set("n", "<leader>h", function() vim.lsp.buf.signature_help() end, opts)
end)

-- to learn how to use mason.nvim with lsp-zero
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
--
--



-- lsp config for mojo
-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/configs/mojo.lua
-- https://forum.modular.com/t/mojo-lsp-setup-for-neovim/501
-- In order to check installation guide :help lspconfig-all
-- Be sure to have built magic + Mojo, refer to the official guide: https://docs.modular.com/mojo/manual/get-started/
-- require('lspconfig').mojo.setup({
vim.lsp.config("mojo",{
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

-- require("lspconfig").ts_ls.setup({
-- 	init_options = {
-- 		plugins = {
-- 			{
-- 				name = '@vue/typescript-plugin',
-- 				location = vim.fn.stdpath 'data' ..
-- 				'/mason/packages/vue-language-server/node_modules/@vue/language-server',
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
	ensure_installed = { 'bashls',  'vtsls', 'rust_analyzer', 'pyright', 'html', 'vuels', 'vue_ls', 'htmx', 'clangd', 'astro',
		'lua_ls',
		'tailwindcss', 'jsonls', 'dockerls', 'docker_compose_language_service', 'zls', 'marksman', 'sqlls',
		'texlab', 'emmet_language_server', 'asm_lsp','sqls' },
	handlers = {
		lsp_zero.default_setup,
		lua_ls = function()
			local lua_opts = lsp_zero.nvim_lua_ls()
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			-- require('lspconfig').lua_ls.setup(lua_opts)
			-- require('lspconfig').lua_ls.setup { options = lua_opts, capabilities = capabilities }
			vim.lsp.config("lua_ls",{ options = lua_opts, capabilities = capabilities })
		end,
	}
})


local vue_language_server_path = vim.fn.expand '$MASON/packages' ..
'/vue-language-server' .. '/node_modules/@vue/language-server'
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
	filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
}
-- If you are on most recent `nvim-lspconfig`
local vue_ls_coonfig = {}
-- If you are not on most recent `nvim-lspconfig` or you want to override
local vue_ls_config = {
	on_init = function(client)
		client.handlers['tsserver/request'] = function(_, result, context)
			local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = 'vtsls' })
			if #clients == 0 then
				vim.notify('Could not find `vtsls` lsp client, `vue_ls` would not work without it.',
					vim.log.levels.ERROR)
				return
			end
			local ts_client = clients[1]

			local param = unpack(result)
			local id, command, payload = unpack(param)
			ts_client:exec_cmd({
				title = 'vue_request_forward', -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
				command = 'typescript.tsserverRequest',
				arguments = {
					command,
					payload,
				},
			}, { bufnr = context.bufnr }, function(_, r)
				local response_data = { { id, r.body } }
				---@diagnostic disable-next-line: param-type-mismatch
				client:notify('tsserver/response', response_data)
			end)
		end
	end,
}
-- local lspconfig = require('lspconfig')
-- lspconfig.vtsls.setup(vtsls_config)
-- lspconfig.vue_ls.setup(vue_ls_config)
-- nvim 0.11 or above
vim.lsp.config('vtsls', vtsls_config)
vim.lsp.config('vue_ls', vue_ls_config)
vim.lsp.enable({ 'vtsls', 'vue_ls' })
