
return {
	"ThePrimeagen/harpoon",
	keys = {
		{ "<leader>a", function() require('harpoon.mark').add_file() end },
		{ "<C-e>", function() require('harpoon.ui').toggle_quick_menu() end },

		{ "<C-y>", function() require('harpoon.ui').nav_file(1) end },
		{ "<C-u>", function() require('harpoon.ui').nav_file(2) end },
		{ "<C-i>", function() require('harpoon.ui').nav_file(3) end },
		{ "<C-o>", function() require('harpoon.ui').nav_file(4) end },
	}

}
