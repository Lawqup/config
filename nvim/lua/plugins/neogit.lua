return {
	{
		"FabijanZulj/blame.nvim",
		lazy = false,
		config = function()
			require('blame').setup {}
		end,

	},
	{
		'NeogitOrg/neogit',
		dependencies = {
			'nvim-lua/plenary.nvim', -- required

			-- Only one of these is needed, not both.
			'nvim-telescope/telescope.nvim', -- optional
		},
		keys = {
			{ '<C-x>g',
			function ()
				local bufname = vim.api.nvim_buf_get_name(0)
				local cwd

				-- Check if we're in an Oil buffer
				if bufname:match("^oil://") then
					-- Extract the path from the Oil URL (remove the "oil://" prefix)
					cwd = bufname:gsub("^oil://", "")
				else
					-- For regular files, use the file's directory
					local filepath = vim.fn.expand('%:p')
					cwd = filepath ~= "" and vim.fn.expand('%:p:h') or vim.fn.getcwd()
				end

				-- Open Neogit with the determined directory
				require('neogit').open({ cwd = cwd })
			end
			},
		},
		config = true
	}
}
