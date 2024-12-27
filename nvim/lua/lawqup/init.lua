-- Maps leader, should be before Lazy
require("lawqup.remap")
require("lawqup.lazy")
require("lawqup.ui")

vim.api.nvim_set_option("clipboard", "unnamed")

require("mini.misc").setup_auto_root()

vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		local mode = vim.api.nvim_get_mode().mode
		local filetype = vim.bo.filetype
		if vim.bo.modified == true and mode == 'n' and filetype ~= "oil" then
			vim.cmd('lua vim.lsp.buf.format()')
		else
		end
	end
})
