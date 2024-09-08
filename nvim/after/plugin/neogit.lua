local neogit = require('neogit')

vim.keymap.set("n", "<C-x>g", function() neogit.open() end)
