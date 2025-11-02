require("dapui").setup()
-- keymaps DAP-UI

-- vim.keymap.set("n", "<leader>dbg", function() require("dapui").open() end)
-- vim.keymap.set("n", "<leader>dbg", function() require("dapui").close() nd)
vim.keymap.set("n", "<leader>dbg", function() require("dapui").toggle() end)
