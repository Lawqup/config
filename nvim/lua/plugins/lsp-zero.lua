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
		event = 'InsertEnter',
		dependencies = {
			'L3MON4D3/LuaSnip',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
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
						border = "rounded", -- single|rounded|none
						-- custom colors
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder,Search:None", -- BorderBG|FloatBorder
					},
					documentation = {
						border = "rounded", -- single|rounded|none
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
						fmt.kind = " " .. (cmp_kinds[strings[2]] or "") -- concatenate icon based on kind

						-- append customized kind text
						fmt.kind = fmt.kind .. " " -- just an extra space at the end
						fmt.menu = strings[2] ~= nil and ("  " .. (strings[2] or "")) or ""
						return fmt
					end,
				},
			})
		end

	},
	-- LSP
	{
		'neovim/nvim-lspconfig',
		cmd = {'LspInfo', 'LspInstall', 'LspStart'},
		event = {'BufReadPre', 'BufNewFile'},
		dependencies = {
			{'hrsh7th/cmp-nvim-lsp'},
			{'williamboman/mason.nvim'},
			{'williamboman/mason-lspconfig.nvim'},
		},
		config = function()
			local lsp_zero = require('lsp-zero')

			-- lsp_attach is where you enable features that only work
			-- if there is a language server active in the file
			local lsp_attach = function(client, bufnr)
				local opts = {buffer = bufnr}

				vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
				vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
				vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
				vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
				vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
				vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
				vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
				vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
				vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
				vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
			end

			lsp_zero.extend_lspconfig({
				sign_text = true,
				lsp_attach = lsp_attach,
				capabilities = require('cmp_nvim_lsp').default_capabilities()
			})

			require('mason-lspconfig').setup({
				ensure_installed = {'pylsp', 'lua_ls', 'rust_analyzer'},
				handlers = {
					function(server_name)
						require('lspconfig')[server_name].setup({})
					end,

					pylsp = function ()
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
					end
				}
			})
		end
	}
}
