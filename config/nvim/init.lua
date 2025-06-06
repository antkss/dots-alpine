-- DON'T EVEN EDIT THIS FILE--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

-- Example using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.maplocalleader = "\\" -- Same for `maplocalleader`
vim.wo.number = true
require("lazy").setup("plugins",{

	change_detection = {
		notify = false,
	},
	checker = { enabled = false },
	performance = {
		rtp = {
		    -- disable some rtp plugins
		    disabled_plugins = {
			"gzip",
			-- "matchit",
			-- "matchparen",
			-- "netrwPlugin",
			-- "tarPlugin",
			"tohtml",
			"tutor",
			-- "zipPlugin",
		    },
		},
	    },
})
vim.o.updatetime = 250
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
-- vim.api.nvim_exec(
-- 	[[
--     augroup YankHighlight
-- 	autocmd!
-- 	autocmd TextYankPost * silent! lua vim.highlight.on_yank()
--     augroup end
--
-- ]],
-- 	false
-- )
vim.lsp.set_log_level("off")

require("config")


