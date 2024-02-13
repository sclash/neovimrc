-- Default options:
require('kanagawa').setup({
	compile = false, -- enable compiling the colorscheme
	undercurl = true, -- enable undercurls
	commentStyle = { italic = true },
	functionStyle = {},
	keywordStyle = { italic = true },
	statementStyle = { bold = true },
	typeStyle = {},
	transparent = false, -- do not set background color
	dimInactive = false, -- dim inactive window `:h hl-NormalNC`
	terminalColors = true, -- define vim.g.terminal_color_{0,17}
	colors = {      -- add/modify theme and palette colors
		palette = {},
		theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
	},
	overrides = function(colors) -- add/modify highlights
		return {}
	end,
	theme = "wave", -- Load "wave" theme when 'background' option is not set
	-- theme = "dragon", -- Load "wave" theme when 'background' option is not set
	background = { -- map the value of 'background' option to a theme
		dark = "dragon", -- try "dragon" !
		light = "lotus"
	},
})

require('onedark').setup({
	term_colors = false,
	transparent = false,
	style = 'warmer',
	colors = {
	},
	highlights = {
	}
	-- bg = { "black" }
})

require('catppuccin').setup({
	-- flavour = "mocha";
	transparent_background = true,
	color_overrides = {
		mocha = {
			-- base = "#212120", -- VSCode
			-- base = "#0B0B09",
			-- base = "#161313",
			-- base = "#1A1818",
			base = "#171515",
			mantle = "#000000",
			crust = "#000000"
		}
	}
})
-- require('onedark').load()
-- vim.cmd("colorscheme kanagawa")
-- vim.cmd("colorscheme onedark")
vim.cmd("colorscheme catppuccin-mocha")
--
-- vim.api.nvim_set_hl(0, "Normal", {bg = "#1e1e21"})
-- vim.api.nvim_set_hl(0, "Normal", {bg = "#151517"})
-- vim.api.nvim_set_hl(0, "LineNr", {bg = "#151517"})
-- vim.api.nvim_set_hl(0, "SignColumn", {bg = "#151517"})
