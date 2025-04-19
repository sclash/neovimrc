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
require('lspconfig').mojo.setup({
	default_config = {
		cmd = { 'mojo-lsp-server' },
		filetypes = { 'mojo' },
		root_dir = function(fname)
			return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
		end,
		single_file_support = true,
	},
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
require("lspconfig").volar.setup {
	-- add filetypes for typescript, javascript and vue
	filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
	init_options = {
		vue = {
			-- disable hybrid mode
			hybridMode = false,
		},
	},
}

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
	ensure_installed = { 'bashls', 'ts_ls', 'rust_analyzer', 'pyright', 'html', 'volar', 'htmx', 'clangd', 'astro',
		'lua_ls',
		'tailwindcss', 'jsonls', 'dockerls', 'docker_compose_language_service', 'zls', 'marksman', 'sqlls',
		'texlab', 'emmet_language_server' },
	handlers = {
		lsp_zero.default_setup,
		lua_ls = function()
			local lua_opts = lsp_zero.nvim_lua_ls()
			require('lspconfig').lua_ls.setup(lua_opts)
		end,
	}
})

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }

-- this is the function that loads the extra snippets to luasnip
-- from rafamadriz/friendly-snippets
require('luasnip.loaders.from_vscode').lazy_load()

cmp.setup({
	sources = {
		{ name = 'path' },
		{ name = 'nvim_lsp' },
		{ name = 'nvim_lua' },
		{ name = 'luasnip', keyword_length = 2 },
		{ name = 'buffer',  keyword_length = 3 },
	},
	formatting = lsp_zero.cmp_format(),
	mapping = cmp.mapping.preset.insert({
		['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
		['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
		-- ['<C-y>'] = cmp.mapping.confirm({ select = true }),
		['<Enter>'] = cmp.mapping.confirm({ select = true }),
		['<C-Space>'] = cmp.mapping.complete(),
	}),
})
