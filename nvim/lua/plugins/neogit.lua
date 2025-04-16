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
			{ '<C-x>g', '<cmd>Neogit cwd=%:p:h<cr>' },
		},
		config = true
	}
}
