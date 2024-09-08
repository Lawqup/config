require("oil").setup({
	default_file_explorer = true,
	keymaps = {
		["h"] = "actions.parent",
		["l"] = "actions.select",
	},
})

vim.keymap.set("n", "<C-x><C-j>", vim.cmd.Oil)
