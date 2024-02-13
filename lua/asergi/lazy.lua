require('lazy').setup({

	-- FUNDAMENTAL
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.5',
		-- or                              , branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},

	--THEMES
	{ "rebelot/kanagawa.nvim" },
	{ 'navarasu/onedark.nvim' },
	{ 'catppuccin/nvim',                 name = 'catpuccin', priority = 1000 },

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

	--- Uncomment the two plugins below if you want to manage the language servers from neovim
	{ 'williamboman/mason.nvim' },
	{ 'williamboman/mason-lspconfig.nvim' },
	{ 'WhoIsSethDaniel/mason-tool-installer.nvim' },

	{ 'VonHeikemen/lsp-zero.nvim',                branch = 'v3.x' },
	{ 'neovim/nvim-lspconfig' },
	{ 'hrsh7th/cmp-nvim-lsp' },
	{ 'hrsh7th/nvim-cmp' },
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
	{ 'preservim/tagbar' },

	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' }
	},

	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

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

})
