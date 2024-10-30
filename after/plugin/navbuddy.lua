local navbuddy = require("nvim-navbuddy")

-- require("lspconfig").clangd.setup {
--     on_attach = function(client, bufnr)
--         navbuddy.attach(client, bufnr)
--     end
-- }
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
