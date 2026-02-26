require("pyworks").setup({
	-- Python environment settings
	python = {
		use_uv = true, -- Use uv for faster package management (10-100x faster than pip)
		preferred_venv_name = ".venv",
		auto_install_essentials = true,
		essentials = { "pynvim", "ipykernel", "jupyter_client", "jupytext", "numpy", "pandas", "matplotlib" },
	},

	-- Package detection settings
	packages = {
		-- Patterns for detecting custom/local packages (won't suggest installing these)
		custom_package_prefixes = {
			"^my_", "^custom_", "^local_", "^internal_", "^private_",
			"^app_", "^lib_", "^src$", "^utils$", "^helpers$",
		},
	},

	-- Cache TTL in seconds
	cache = {
		kernel_list = 60,
		installed_packages = 300,
	},

	-- Notification settings
	notifications = {
		verbose_first_time = true,
		silent_when_ready = true,
		show_progress = true,
		debug_mode = true,
	},

	-- Auto-detection
	auto_detect = true, -- Automatically detect and setup on file open

	-- Image rendering (for inline plots)
	image_backend = "kitty", -- "kitty" or "ueberzug"

	-- Skip auto-configuration of specific features (all default to false)
	skip_molten = false, -- Skip Molten configuration
	skip_jupytext = false, -- Skip jupytext setup (set true if using jupytext.nvim)
	skip_image = false, -- Skip image.nvim configuration
	skip_keymaps = false, -- Skip keymap setup (define your own)
})
