local telescope = require('telescope')
local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
vim.keymap.set('n', '<C-x><C-f>', builtin.find_files, {})
vim.keymap.set('n', '<C-x><C-h>', builtin.buffers, {})

vim.keymap.set('n', '<C-x>s', builtin.live_grep, {})

vim.keymap.set('n', '<C-p><C-f>', builtin.git_files, {})


vim.keymap.set('n', '<C-h>k', builtin.keymaps, {})

vim.keymap.set('n', '<C-s>', builtin.current_buffer_fuzzy_find, {})

telescope.setup({
	defaults = {
		mappings = {
			n = {
				["<C-k>"] = actions.toggle_selection + actions.move_selection_worse,
				["<C-j>"] = actions.toggle_selection + actions.move_selection_better,
			},
			i = {
				["<C-k>"] = actions.toggle_selection + actions.move_selection_worse,
				["<C-j>"] = actions.toggle_selection + actions.move_selection_better,
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
