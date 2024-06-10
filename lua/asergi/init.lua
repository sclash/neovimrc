--require("asergi.remaps.custom_remaps")
require("asergi.remaps")
vim.wo.number = true
vim.wo.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.updatetime = 50
--vim.opt.termguicolors = true
-- vim.api.nvim_set_hl(0, "Normal", { bg = "black" })

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("asergi.lazy")
