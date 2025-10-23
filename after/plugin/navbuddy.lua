local navbuddy = require("nvim-navbuddy")

-- require("lspconfig").clangd.setup {
vim.lsp.config("clangd", {
	-- capabalities = clang_capabilities,
	-- cmd = {
	-- 	"clangd",
	-- 	"--offset-encoding=utf-16",
	-- 	"--fallback-style=llvm",
	-- },
    on_attach = function(client, bufnr)
		-- if client.name == "clangd" then
		-- 	client.server_capabilities.documentFormattingProvider = true
		-- end
        navbuddy.attach(client, bufnr)
    end
})

--
--
-- require("lspconfig").zls.setup {
--     on_attach = function(client, bufnr)
--         navbuddy.attach(client, bufnr)
--     end
-- }
--
--


vim.keymap.set('n', '<leader>nb', "<cmd>Navbuddy<CR>")
