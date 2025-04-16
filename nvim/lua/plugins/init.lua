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

	{
		'numToStr/Comment.nvim',
		config = true
	},

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
	},
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true
	},
	{
		'jedrzejboczar/possession.nvim',
		keys = {
			{ "<leader>S", mode = { "n", "x", "o", "v" }, "<cmd> Telescope possession list<cr>", desc = "Sessions" },
		},
		config = function ()
			require('possession').setup({
				autosave = {
					current = true,  -- or fun(name): boolean
					cwd = false, -- or fun(): boolean
					tmp = false,  -- or fun(): boolean
					tmp_name = 'tmp', -- or fun(): string
					on_load = true,
					on_quit = true,
				},
				autoload = 'last', -- or 'last' or 'auto_cwd' or 'last_cwd' or fun(): string
			})
			require('telescope').load_extension('possession')
		end,
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons', 'jedrzejboczar/possession.nvim' },
		config = function ()
			local function my_session_name()
				return require('possession.session').get_session_name() or ''
			end

			require('lualine').setup({
				sections = { lualine_a = { my_session_name } }
			})
		end,
	}
}
