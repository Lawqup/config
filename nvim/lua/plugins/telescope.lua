return {

	'nvim-telescope/telescope.nvim', tag = '0.1.8',
	-- or                            , branch = '-1.1.x',
	dependencies = {
		'nvim-lua/plenary.nvim',
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build = 'make'
		},
	},

	keys = {
		{'<C-x><C-f>', '<cmd>Telescope find_files<cr>'},
		{'<C-x><C-h>', '<cmd>Telescope buffers<cr>'},
		{'<C-p><C-f>', '<cmd>Telescope git_files<cr>'},
		{'<C-h>k', '<cmd>Telescope keymaps<cr>'},
		{'<C-s>', '<cmd>Telescope current_buffer_fuzzy_find<cr>'},
		{'<C-x>s', '<cmd>Telescope live_grep<cr>'},
	},

	config = function ()
		local actions = require('telescope.actions')
		local telescope = require("telescope")
		telescope.load_extension('fzf')
		telescope.setup({
			defaults = {
				mappings = {
					n = {
						["<C-k>"] = actions.move_selection_worse,
						["<C-j>"] = actions.move_selection_better,
					},
					i = {
						["<C-k>"] = actions.move_selection_worse,
						["<C-j>"] = actions.move_selection_better,
					},
				}
			},
			extensions = {
				fzf = {
					fuzzy = true, -- false will only do exact matching. You can do exact matching any time by prefixing with ' e.g. 'my-search-term
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
					-- the default case_mode is "smart_case"
				},
			},
		})
	end
}
