require('lazy').setup({
	-- nvim v0.8.0
	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
		}
	},
	{ 'Vigemus/iron.nvim' },
	{ 'brenoprata10/nvim-highlight-colors' },
	{ 'sindrets/diffview.nvim' },
	{ "lewis6991/gitsigns.nvim" },
	-- FUNDAMENTAL
	-- { "nvim-treesitter/nvim-treesitter",   lazy = false, build = ":TSUpdate" },
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup()
			require("nvim-treesitter").install({
				"lua", "nix", "markdown", "markdown_inline", "bash", "json", "yaml",
			})
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(ev)
					pcall(vim.treesitter.start, ev.buf)
				end,
			})
		end,
	},
	{
		'nvim-telescope/telescope.nvim',
		version = '*',
		dependencies = {
			'nvim-lua/plenary.nvim',
			-- optional but recommended
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
		}
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- Library paths can be absolute
				"~/projects/my-awesome-lib",
				-- Or relative, which means they will be resolved from the plugin dir.
				"lazy.nvim",
				-- It can also be a table with trigger words / mods
				-- Only load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library",        words = { "vim%.uv" } },
				-- always load the LazyVim library
				"LazyVim",
				-- Only load the lazyvim library when the `LazyVim` global is found
				{ path = "LazyVim",                   words = { "LazyVim" } },
				-- Load the wezterm types when the `wezterm` module is required
				-- Needs `justinsgithub/wezterm-types` to be installed
				{ path = "wezterm-types",             mods = { "wezterm" } },
				-- Load the xmake types when opening file named `xmake.lua`
				-- Needs `LelouchHe/xmake-luals-addon` to be installed
				{ path = "xmake-luals-addon/library", files = { "xmake.lua" } },
			},
			-- always enable unless `vim.g.lazydev_enabled = false`
			-- This is the default
			enabled = function(root_dir)
				return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
			end,
			-- disable when a .luarc.json file is found
			-- enabled = function(root_dir)
			-- 	return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
			-- end,
		},
	},
	--THEMES
	{ "rebelot/kanagawa.nvim" },
	{ 'navarasu/onedark.nvim' },
	{ 'catppuccin/nvim',      name = 'catpuccin', priority = 1000 },
	{ 'rose-pine/nvim',       name = 'rose-pine' },

	-- file system navigator
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		}
	},
	{ "mbbill/undotree" },
	{ "tpope/vim-fugitive" },

	{ 'neovim/nvim-lspconfig' },
	-- { 'hrsh7th/cmp-nvim-lsp' },
	-- { 'hrsh7th/nvim-cmp' },
	{ 'L3MON4D3/LuaSnip' },

	{
		'numToStr/Comment.nvim',
		dependencies = {
			'JoosepAlviste/nvim-ts-context-commentstring'
		},
	},
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		opts = {} -- this is equalent to setup({}) function
	},


	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function() vim.fn["mkdp#util#install"]() end,
	},
	{ 'tpope/vim-surround' },
	{
		'ThePrimeagen/harpoon',
		branch = 'harpoon2',
		dependencies = { 'nvim-lua/plenary.nvim' }

	},
	-- { 'preservim/tagbar' },
	-- { 'simrat39/symbols-outline.nvim' },
	{
		"SmiteshP/nvim-navbuddy",
		dependencies = {
			"neovim/nvim-lspconfig",
			"SmiteshP/nvim-navic",
			"MunifTanjim/nui.nvim",
		},
		opts = { lsp = { auto_attach = true } }
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' }
	},

	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
	{
		"folke/trouble.nvim",
		opts = {},
		cmd = "Trouble",
	},

	-- noice.nvim
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- add any options here
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		}
	},
	{
		'stevearc/oil.nvim',
		-- opts = {},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"nvim-mini/mini.icons",
		-- No need to copy this inside `setup()`. Will be used automatically.
		-- Icon style: 'glyph' or 'ascii'
		style              = 'glyph',

		-- Customize per category. See `:h MiniIcons.config` for details.
		default            = {},
		directory          = {},
		extension          = {},
		file               = {},
		filetype           = {},
		lsp                = {},
		os                 = {},

		-- Control which extensions will be considered during "file" resolution
		use_file_extension = function(ext, file) return true end,
	},

	{
		"mfussenegger/nvim-dap",
		event = "VeryLazy",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"theHamsta/nvim-dap-virtual-text",
		},
	},

	-- vim-lsp (for sqls LSP)
	{ 'prabirshrestha/vim-lsp' },

	-- blink.cmp nvim
	{
		'saghen/blink.cmp',
		-- 	-- optional: provides snippets for the snippet source
		dependencies = { 'rafamadriz/friendly-snippets' },
		--
		-- 	-- use a release tag to download pre-built binaries
		version = '1.*',
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',
		--
		-- opts = {
		-- 	-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
		-- 	-- 'super-tab' for mappings similar to vscode (tab to accept)
		-- 	-- 'enter' for enter to accept
		-- 	-- 'none' for no mappings
		-- 	--
		-- 	-- All presets have the following mappings:
		-- 	-- C-space: Open menu or open docs if already open
		-- 	-- C-n/C-p or Up/Down: Select next/previous item
		-- 	-- C-e: Hide menu
		-- 	-- C-k: Toggle signature help (if signature.enabled = true)
		-- 	--
		-- 	-- See :h blink-cmp-config-keymap for defining your own keymap
		--
		-- 	keymap = {
		-- 		preset = 'none',
		-- 		['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
		-- 		['<C-e>'] = { 'hide' },
		-- 		['<C-y>'] = { 'select_and_accept' },
		-- 		-- ['<C-Enter>'] = { 'select_and_accept' },
		--
		-- 		['<Up>'] = { 'select_prev', 'fallback' },
		-- 		['<Down>'] = { 'select_next', 'fallback' },
		-- 		['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
		-- 		['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
		--
		-- 		['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
		-- 		['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
		--
		-- 		['<Tab>'] = { 'snippet_forward', 'fallback' },
		-- 		['<S-Tab>'] = { 'snippet_backward', 'fallback' },
		--
		-- 		['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
		-- 	},
		--
		-- 	appearance = {
		-- 		-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- 		-- Adjusts spacing to ensure icons are aligned
		-- 		nerd_font_variant = 'mono'
		-- 	},
		--
		-- 	-- (Default) Only show the documentation popup when manually triggered
		-- 	completion = { documentation = { auto_show = true } },
		--
		-- 	-- Default list of enabled providers defined so that you can extend it
		-- 	-- elsewhere in your config, without redefining it, due to `opts_extend`
		-- 	sources = {
		-- 		default = { 'lsp', 'path', 'snippets', 'buffer' },
		-- 	},
		--
		-- 	-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
		-- 	-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
		-- 	-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
		-- 	--
		-- 	-- See the fuzzy documentation for more information
		-- 	fuzzy = { implementation = "prefer_rust_with_warning" }
		-- },
		opts_extend = { "sources.default" }
	},
}, {

	{ rocks = { enabled = false, hererokcs = true } }
})
