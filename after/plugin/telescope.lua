require('telescope').setup({
	defaults = {
		file_ignore_patterns = {
			"node_modules",
			"__pycache__",
			"venv",
			".git",
			".cache",
			-- Excludes files that contain no period (e.g., executables, build artifacts)
			-- [=[^[^.]+$]=],
		},
		find_files = {
			hidden = true,
		}
	},
	pickers = {
		find_files = {
			hidden = true,
		},
	},
})

-- require('telescope').load_extension('harpoon')

local builtin = require('telescope.builtin')



vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fG', builtin.git_files, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
