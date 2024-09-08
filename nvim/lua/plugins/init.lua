return {
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.8',
		-- or                            , branch = '-1.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},

	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
	},

	{
		'catppuccin/nvim',
		as = 'catppuccin',
		config = function()
			vim.cmd('colorscheme catppuccin')
		end
	},

	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate'
	},

	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" }
	},

	"ThePrimeagen/harpoon",
	"mbbill/undotree",

	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
			{ "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
			{ "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
			{ "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
		},
	},

	'numtostr/comment.nvim',
}
