local cmp_kinds = {
	Text = "",
	Method = "",
	Function = "",
	Constructor = "",
	Field = "",
	Variable = "",
	Class = "",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "",
	Event = "",
	Operator = "",
	TypeParameter = "",
}

return {
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v4.x',
		lazy = true,
		config = false,
	},
	{
		'williamboman/mason.nvim',
		lazy = false,
		config = true,
	},

	-- Autocompletion
	{
		'hrsh7th/nvim-cmp',
		lazy = false,
		dependencies = {
			'L3MON4D3/LuaSnip',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'saadparwaiz1/cmp_luasnip',
			'rafamadriz/friendly-snippets',
			'onsails/lspkind.nvim',
		},
		config = function()
			local cmp = require('cmp')
			local lspkind = require("lspkind")

			cmp.setup({
				sources = cmp.config.sources({
					{ name = "nvim_lsp" }, -- lsp
					{ name = "luasnip" }, -- luasnips
					{ name = "buffer" }, -- text within the current buffer
					{ name = "path" }, -- file system paths
				}),
				mapping = cmp.mapping.preset.insert({
					['<C-Space>'] = cmp.mapping.complete(),
					['<TAB>'] = cmp.mapping.confirm({ select = true }),
					['<C-u>'] = cmp.mapping.scroll_docs(-4),
					['<C-d>'] = cmp.mapping.scroll_docs(4),
					['<C-j>'] = cmp.mapping.select_next_item(),
					['<C-k>'] = cmp.mapping.select_prev_item(),
				}),
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},
				window = {
					completion = {
						border = "rounded",       -- single|rounded|none
						-- custom colors
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder,Search:None", -- BorderBG|FloatBorder
					},
					documentation = {
						border = "rounded",       -- single|rounded|none
						-- custom colors
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder,Search:None", -- BorderBG|FloatBorder
					},
				},
				formatting = {
					fields = { "kind", "abbr", "menu" },
					format = function(entry, item)
						-- vscode like icons for cmp autocompletion
						local fmt = lspkind.cmp_format({
							-- with_text = false, -- hide kind beside the icon
							mode = "symbol_text",
							maxwidth = 50,
							ellipsis_char = "...",
						})(entry, item)

						-- customize lspkind format
						local strings = vim.split(fmt.kind, "%s", { trimempty = true })

						-- strings[1] -> default icon
						-- strings[2] -> kind

						-- set different icon styles
						fmt.kind = " " ..
						    (cmp_kinds[strings[2]] or "") -- concatenate icon based on kind

						-- append customized kind text
						fmt.kind = fmt.kind .. " " -- just an extra space at the end
						fmt.menu = strings[2] ~= nil and ("  " .. (strings[2] or "")) or ""
						return fmt
					end,
				},
			})

			cmp.setup.cmdline('/', {
				mapping = cmp.mapping.preset.cmdline(),

				sources = {
					{ name = 'buffer' }
				}
			})

			cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),

				sources = cmp.config.sources({
					{ name = 'path' }
				}, {
					{
						name = 'cmdline',
						option = {
							ignore_cmds = { 'Man', '!', 'w', 'wa', 'q', 'qa', 'wq', 'wqa' }
						}
					}
				})
			})

		end

	},
	{
		'aznhe21/actions-preview.nvim',
		config = true
	},
	-- LSP
	{
		'neovim/nvim-lspconfig',
		cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
		event = { 'BufReadPre', 'BufNewFile' },
		dependencies = {
			{ 'hrsh7th/cmp-nvim-lsp' },
			{ 'williamboman/mason.nvim' },
			{ 'williamboman/mason-lspconfig.nvim' },
		},
		config = function()
			local lsp_zero = require('lsp-zero')

			-- lsp_attach is where you enable features that only work
			-- if there is a language server active in the file
			local lsp_attach = function(client, bufnr)
				local opts = { buffer = bufnr }

				vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
				vim.keymap.set('n', 'gd', function() require('telescope.builtin').lsp_definitions() end,
					opts)
				vim.keymap.set('n', 'gD', function() require('telescope.builtin').lsp_declarations() end,
					opts)
				vim.keymap.set('n', 'gi',
					function() require('telescope.builtin').lsp_implementations() end, opts)
				vim.keymap.set('n', 'go',
					function() require('telescope.builtin').lsp_type_definitions() end, opts)
				vim.keymap.set('n', 'gr', function() require('telescope.builtin').lsp_references() end,
					opts)
				vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
				vim.keymap.set('n', 'gR', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
				vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>',
					opts)
				vim.keymap.set('n', 'ge', '<cmd>lua vim.diagnostic.open_float(0, {scope="line"})<CR>',
					opts)
				vim.keymap.set({ 'v', 'n' }, 'gA', require("actions-preview").code_actions, opts)

				vim.keymap.set('n', 'gh', '<cmd>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), { bufnr })<CR>', opts, "Toggle Inlay Hints")

			end

			lsp_zero.extend_lspconfig({
				sign_text = true,
				lsp_attach = lsp_attach,
				capabilities = require('cmp_nvim_lsp').default_capabilities()
			})

			require('mason-lspconfig').setup({
				ensure_installed = { 'pylsp', 'lua_ls', 'rust_analyzer@2022-08-15', 'clangd' },
				handlers = {
					function(server_name)
						require('lspconfig')[server_name].setup({})
					end,

					pylsp = function()
						require('lspconfig').pylsp.setup({
							settings = {
								pylsp = {
									plugins = {
										pycodestyle = {
											maxLineLength = 120
										}
									}
								}
							}
						})
					end,
				}
			})
		end
	}
}
