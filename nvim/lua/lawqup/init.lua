-- Maps leader, should be before Lazy
require("lawqup.remap")
require("lawqup.lazy")
require("lawqup.ui")

vim.api.nvim_set_option("clipboard", "unnamed")

require("mini.misc").setup_auto_root()

-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	callback = function()
-- 		local mode = vim.api.nvim_get_mode().mode
-- 		local filetype = vim.bo.filetype
-- 		if vim.bo.modified == true and mode == 'n' and filetype == "rust" then
-- 			vim.cmd('lua vim.lsp.buf.format()')
-- 		else
-- 		end
-- 	end
-- })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "cucumber",
	callback = function()
		vim.opt_local.tabstop = 4 -- A TAB character looks like 4 spaces
		vim.opt_local.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
		vim.opt_local.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
		vim.opt_local.shiftwidth = 4 -- Number of spaces inserted when indenting
	end
})

