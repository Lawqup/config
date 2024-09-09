return {
	-- We want to load Oil as the default file explorer on startup
	lazy = false,
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },

	keys = {
		{ "<C-x><C-j>", '<cmd>Oil<cr>' }
	},

	opts = {
		default_file_explorer = true,
		use_default_keymaps = false,
		keymaps = {
			["h"] = "actions.parent",
			["l"] = "actions.select",
			["<left>"] = "actions.parent",
			["<right>"] = "actions.select",
			["<C-i>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
			["<C-o>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
			["g?"] = "actions.show_help",
			["<CR>"] = "actions.select",
			["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
			["<C-p>"] = "actions.preview",
			["<C-c>"] = "actions.close",
			["<C-l>"] = "actions.refresh",
			["-"] = "actions.parent",
			["_"] = "actions.open_cwd",
			["`"] = "actions.cd",
			["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
			["gs"] = "actions.change_sort",
			["gx"] = "actions.open_external",
			["g."] = "actions.toggle_hidden",
			["g\\"] = "actions.toggle_trash",
		},
	},
}

