return {
	"dhananjaylatkar/cscope_maps.nvim",
	dependencies = {
		"folke/which-key.nvim", -- optional [for whichkey hints]
		"nvim-telescope/telescope.nvim", -- optional [for picker="telescope"]
		"ibhagwan/fzf-lua", -- optional [for picker="fzf-lua"]
		"echasnovski/mini.pick", -- optional [for picker="mini-pick"]
		"nvim-tree/nvim-web-devicons", -- optional [for devicons in telescope, fzf or mini.pick]
	},
	opts = {
		-- maps related defaults
		disable_maps = false, -- "true" disables default keymaps
		skip_input_prompt = true, -- "true" doesn't ask for input
		prefix = "<C-c>", -- prefix to trigger maps

		-- cscope related defaults
		cscope = {
			-- location of cscope db file
			db_file = "./cscope.out", -- DB or table of DBs
			-- NOTE:
			--   when table of DBs is provided -
			--   first DB is "primary" and others are "secondary"
			--   primary DB is used for build and project_rooter
			-- cscope executable
			exec = "cscope", -- "cscope" or "gtags-cscope"
			-- choose your fav picker
			picker = "telescope", -- "quickfix", "telescope", "fzf-lua" or "mini-pick"
			-- "true" does not open picker for single result, just JUMP
			skip_picker_for_single_result = false, -- "false" or "true"
			-- these args are directly passed to "cscope -f <db_file> <args>"
			db_build_cmd_args = { "-bqkv" },
			-- try to locate db_file in parent dir(s)
			project_rooter = {
				enable = true, -- "true" or "false"
				-- change cwd to where db_file is located
				change_cwd = false, -- "true" or "false"
			},
		}
	},

	config = true
}
