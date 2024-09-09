-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<leader>s", vim.cmd.vsplit)
vim.keymap.set("n", "<leader>d", vim.cmd.split)

vim.keymap.set("n", "<leader>x", vim.cmd.quit)
vim.keymap.set("n", "<leader>w", vim.cmd.write)
