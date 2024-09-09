return {
	{
		'catppuccin/nvim',
		as = 'catppuccin',
		config = function()
			vim.cmd('colorscheme catppuccin')
		end
	},

	{
		"mbbill/undotree",
		keys = {
			{ '<leader>u', '<cmd>UndotreeToggle<cr>' },
		}
	},

	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{ "m", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
			{ "M", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
			{ "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
			{ "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
		},
	},

	'numtostr/comment.nvim',
	'sunaku/tmux-navigate',
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = true
	},

	{
		'echasnovski/mini.misc',
		config = true
	}
}
