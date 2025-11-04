vim.g.mapleader = " "

vim.keymap.set("n", "<leader>E", vim.cmd.Neotree)

vim.keymap.set("i", "<leader><leader>", '<Esc>')

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Open TagbarToggle
vim.keymap.set("n", "<leader>T", vim.cmd.TagbarToggle)

-- remove higlighting
vim.keymap.set("n", "<C-n>", ":nohl<CR>")

-- search word under cursor text
--case SENSITIVE
vim.keymap.set("n", "<C-f>", ":let @/='\\<<C-r><C-w>\\>'<CR>:set hlsearch<CR>")
--case Insensitive
-- vim.keymap.set("n", "<leader>F", ":let @/='\\<<C-r><C-w>\\>'<CR>:set hlsearch<CR>")


-- ThePrimegean remaps
-- https://github.com/ThePrimeagen/neovimrc/
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- substitute word under cursor in the WHOLE file
--
-- Case Insensitive
-- vim.keymap.set("n", "<leader>S", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]])
-- Case SENSITIVE
vim.keymap.set("n", "<leader>S", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]])
-- vim.keymap.set("v", "<leader>S", [[:'<,'>s/\<<C-r><C-w>\>//gI<Left><Left><Left>]])



-- format file using the lsp formatter cnfigures (check after/lsp.lua)
-- vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
vim.keymap.set('n', '<leader>f', function()
	vim.lsp.buf.format({
		filter = function(client)
			-- Exclude clangd from formatting
			return client.name ~= 'clangd'
		end,
	})
end)

vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")



-- NO IDEA
--vis.keymap.set("n", "n", "nzzzv")
