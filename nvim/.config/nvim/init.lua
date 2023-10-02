-- INITIAL SETUP
-- Keep this at the top of the config
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)


-- OPTIONS
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

vim.opt.termguicolors = true

vim.opt.expandtab = false
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "80"
vim.opt.wrap = false

vim.opt.list = true
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 10
vim.opt.fillchars = { eob = ' ' }

vim.opt.cmdheight = 1
vim.opt.laststatus = 0
vim.opt.showmode = false

vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.winminwidth = 5

vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.mouse = "a"
vim.opt.completeopt = 'menu,menuone,noselect'
vim.opt.formatoptions = "jcroqlnt"
vim.opt.wildmode = "longest:full,full"
vim.opt.iskeyword:append('-')
vim.opt.hidden = true  -- Enable modified buffers in background
vim.opt.confirm = true -- confirm to save changes before exiting modified buffer
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
vim.opt.spelllang = { "en" }

if vim.fn.has("nvim-0.9.0") == 1 then
	vim.opt.splitkeep = "screen"
	vim.opt.shortmess = "filnxtToOFWIcC"
end


-- KEYMAPS
vim.keymap.set({ 'n', 'i', 'v' }, '<M-Space>', '<Esc>', { desc = 'Same as <Esc>' })

vim.keymap.set('n', 'x', '"_x', { desc = "Don't yank with 'x'" })
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = "Yank to the system's clipboard" })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = "Yank line to the system's clipboard" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Better scroll down motion" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Better scroll up motion" })

vim.keymap.set("v", "<", "<gv", { desc = 'Indent block to the left' })
vim.keymap.set("v", ">", ">gv", { desc = 'Indent block to the right' })

vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to the window below' })
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to the window on the left' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to the window on the right' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to the window above' })


-- AUTOCOMMANDS
vim.api.nvim_create_autocmd('BufWritePre', {
	pattern = '*.go',
	callback = function()
		vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
	end
})

-- PLUGINS
require("lazy").setup({
		{
			"marko-cerovac/material.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				vim.g.material_style = "deep ocean"
				vim.cmd("colorscheme material")
			end
		},

		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			config = true,
		},

		{
			"neovim/nvim-lspconfig",
			dependencies = {
				"folke/neodev.nvim",
				"williamboman/mason.nvim",
				"williamboman/mason-lspconfig.nvim",
				"hrsh7th/nvim-cmp",
			},
			event = { "BufReadPre", "BufNewFile" },
			config = function()
				require("neodev").setup()
				require("mason").setup({
					ui = {
						border = 'single',
						icons = {
							package_installed = '⏺',
							package_pending = '󰦗',
							package_uninstalled = '',
						}
					}
				})

				require("mason-lspconfig").setup({
					ensure_installed = {
						"bashls",
						"clangd",
						"gopls",
						"lua_ls",
						"marksman",
						"pyright",
						"yamlls",
					}
				})

				-- Global mappings.
				-- See `:help vim.diagnostic.*` for documentation on any of the below functions
				vim.keymap.set('n', '<space>d', vim.diagnostic.open_float)
				vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
				vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
				vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

				-- Use LspAttach autocommand to only map the following keys
				-- after the language server attaches to the current buffer
				vim.api.nvim_create_autocmd('LspAttach', {
					group = vim.api.nvim_create_augroup('UserLspConfig', {}),
					callback = function(ev)
						-- Buffer local mappings.
						-- See `:help vim.lsp.*` for documentation on any of the below functions
						local opts = { buffer = ev.buf }
						vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
						vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
						vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
						vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
						vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
						vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
						vim.keymap.set('n', '<space>wl', function()
							print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
						end, opts)
						vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
						vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
						vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
						vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
						vim.keymap.set('n', '<space>bf', function()
							vim.lsp.buf.format { async = true }
						end, opts)
					end,
				})

				local capabilities = vim.lsp.protocol.make_client_capabilities()
				capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

				local lspconfig = require("lspconfig")
				local util = require("lspconfig/util")

				require("mason-lspconfig").setup_handlers({
					function(server_name)
						lspconfig[server_name].setup({
							capabilities = capabilities
						})
					end,
					["gopls"] = function()
						lspconfig.gopls.setup({
							capabilities = capabilities,
							cmd = { "gopls", "serve" },
							filetypes = { "go", "gomod", "gowork", "gotmpl" },
							root_dir = util.root_pattern("go.work", "go.mod", ".git"),
							settings = {
								gopls = {
									usePlaceholders = true,
									staticcheck = true,
									analyses = {
										unusedparams = true,
									},
								}
							}
						})
					end
				})
			end
		},

		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				"neovim/nvim-lspconfig",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
				"L3MON4D3/LuaSnip",
				"saadparwaiz1/cmp_luasnip",
			},
			config = function()
				-- TODO: check out https://github.com/hrsh7th/nvim-cmp/wiki/Advanced-techniques
				-- when you have treesitter installed
				local cmp = require 'cmp'

				cmp.setup({
					snippet = {
						expand = function(args)
							require('luasnip').lsp_expand(args.body)
						end,
					},
					window = {
						-- completion = cmp.config.window.bordered(),
						-- documentation = cmp.config.window.bordered(),
					},
					mapping = cmp.mapping.preset.insert({
						["<C-p>"] = cmp.mapping.select_prev_item(),
						["<C-n>"] = cmp.mapping.select_next_item(),
						["<C-b>"] = cmp.mapping.scroll_docs(-4),
						["<C-f>"] = cmp.mapping.scroll_docs(4),
						["<C-Space>"] = cmp.mapping.complete(),
						["<C-e>"] = cmp.mapping.abort(),
						["<CR>"] = cmp.mapping.confirm({ select = true }),
					}),
					sources = cmp.config.sources({
						{ name = "nvim_lsp", group_index = 1 },
						--{ name = "nvim_lua", group_index = 1 },
						{ name = "luasnip",  group_index = 1 },
						{ name = "path",     group_index = 2 },
						{ name = "buffer",   group_index = 3 },
					})
				})

				-- Set configuration for specific filetype.
				cmp.setup.filetype('gitcommit', {
					sources = cmp.config.sources({
						{ name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
					}, {
						{ name = 'buffer' },
					})
				})

				-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
				cmp.setup.cmdline({ '/', '?' }, {
					mapping = cmp.mapping.preset.cmdline(),
					sources = {
						{ name = 'buffer' }
					}
				})

				-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
				cmp.setup.cmdline(':', {
					mapping = cmp.mapping.preset.cmdline(),
					sources = cmp.config.sources({
						{ name = 'path' }
					}, {
						{ name = 'cmdline' }
					})
				})

				local cmp_autopairs = require('nvim-autopairs.completion.cmp')
				cmp.event:on(
					"confirm_done",
					cmp_autopairs.on_confirm_done()
				)
			end
		},

		{
			"nvim-telescope/telescope.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim"
			},
			cmd = "Telescope",
			keys = {
				{ "<leader>:",  "<cmd>Telescope command_history<CR>" },
				-- find
				{ "<leader>ff", "<cmd>Telescope find_files<CR>" },
				{ "<leader>fo", "<cmd>Telescope oldfiles<CR>" },
				-- search
				{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<CR>" },
				{ "<leader>sh", "<cmd>Telescope help_tags<CR>" },
				{ "<leader>sg", "<cmd>Telescope live_grep<CR>" },
				-- git
				{ "<leader>gf", "<cmd>Telescope git_files<CR>" },
				{ "<leader>gs", "<cmd>Telescope git_status<CR>" },
				-- lsp
				{ "gr",         "<cmd>Telescope references<CR>" },
				{ "<leader>ss", "<cmd>Telescope lsp_document_symbols<CR>" },
			},
			opts = {
				defaults = {
					file_ignore_patterns = {
						".git/",
						".cache/",
						"node_modules/",
					},
					dynamic_preview_title = true,
					vimgrep_arguments = {
						"rg",
						"--ignore",
						"--hidden",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--trim",
					},
					mappings = {
						i = {
							["<C-h>"] = "which_key",
							["<C-u>"] = false
						}
					}
				},
				pickers = {
					find_files = {
						hidden = true,
						find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
					},
					git_files = {
						hidden = true
					},
					oldfiles = {
						find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
					}
				},
			}
		},

		{
			"phaazon/hop.nvim",
			branch = "v2",
			event = { "BufReadPre", "BufNewFile" },
			config = function()
				local hop = require('hop')
				local directions = require('hop.hint').HintDirection
				local keymap = vim.keymap.set

				hop.setup({
					keys = 'etovxqpdygfblzhckisuran',
				})

				keymap('', 'f', function()
					hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
				end, { remap = true })
				keymap('', 'F', function()
					hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
				end, { remap = true })
				keymap('', 't', function()
					hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
				end, { remap = true })
				keymap('', 'T', function()
					hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
				end, { remap = true })

				keymap('', '<leader>/', function()
					hop.hint_patterns({ direction = directions.AFTER_CURSOR })
				end, { remap = true })
				keymap('', '<leader>?', function()
					hop.hint_patterns({ direction = directions.BEFORE_CURSOR })
				end, { remap = true })

				keymap('', 's', function()
					hop.hint_words()
				end, { remap = true })
				keymap('', 'S', function()
					hop.hint_char1()
				end, { remap = true })

				keymap('', 'g0', function()
					hop.hint_lines()
				end, { remap = true })
				keymap('', 'g_', function()
					hop.hint_lines_skip_whitespace()
				end, { remap = true })
			end
		},
		{
			'nvim-lualine/lualine.nvim',
			dependencies = {
				"nvim-tree/nvim-web-devicons"
			},
			event = "VeryLazy",
			opts = {
				options = {
					icons_enabled = true,
					theme = 'auto',
					component_separators = { left = '|', right = '|' },
					section_separators = { left = '', right = '' },
					disabled_filetypes = {
						statusline = { "alpha" },
						winbar = { "alpha" },
					},
					ignore_focus = {},
					globalstatus = false,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					}
				},
				sections = {
					lualine_a = { 'mode' },
					lualine_b = { 'branch', 'diff' },
					lualine_c = { 'filename' },
					lualine_x = { 'filetype' },
					lualine_y = { 'diagnostics' },
					lualine_z = { 'location' }
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { 'filename' },
					lualine_x = { 'location' },
					lualine_y = {},
					lualine_z = {}

				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {}
			}
		},
		{
			"nvim-treesitter/nvim-treesitter",
			dependencies = {
				"nvim-treesitter/nvim-treesitter-textobjects",
			},
			build = ":TSUpdate",
			event = { "BufReadPost", "BufNewFile" },
			keys = {
				{ "<C-space>", desc = "Increment selection" },
				{ "<BS>",      desc = "Schrink selection",  mode = "x" },
			},
			config = function()
				local configs = require("nvim-treesitter.configs")

				configs.setup({
					ensure_installed = {
						"bash",
						"comment",
						"css",
						"diff",
						"dockerfile",
						"gitignore",
						"html",
						"http",
						"javascript",
						"json",
						"lua",
						"markdown_inline",
						"python",
						"regex",
						"tsx",
						"typescript",
						"yaml",
					},
					highlight = { enable = true },
					indent = { enable = true },
					context_commentstring = { enable = true, enable_autocmd = false },
					incremental_selection = {
						enable = true,
						keymaps = {
							init_selection = "<C-space>",
							node_incremental = "<C-space>",
							scope_incremental = "<nop>",
							node_decremental = "<BS>",
						},
					},
					textobjects = {
						select = {
							enable = true,
							lookahead = true,
							keymaps = {
								["aa"] = "@parameter.outer",
								["ia"] = "@parameter.inner",
								["af"] = "@function.outer",
								["if"] = "@function.inner",
								["ac"] = "@class.outer",
								["ic"] = "@class.inner",
							},
						},
						move = {
							enable = true,
							set_jumps = true,
							goto_next_start = {
								["]m"] = "@function.outer",
								["]]"] = "@class.outer",
							},
							goto_next_end = {
								[']M'] = '@function.outer',
								[']['] = '@class.outer',
							},
							goto_previous_start = {
								['[m'] = '@function.outer',
								['[['] = '@class.outer',
							},
							goto_previous_end = {
								['[M'] = '@function.outer',
								['[]'] = '@class.outer',
							},
						},
						swap = {
							enable = true,
							swap_next = {
								['<leader>a'] = '@parameter.inner',
							},
							swap_previous = {
								['<leader>A'] = '@parameter.inner',
							},
						},
					},
				})
			end
		},

		{
			"lewis6991/gitsigns.nvim",
			event = "BufReadPre",
			opts = {
				signs = {
					add = { text = "▎" },
					change = { text = "▎" },
					delete = { text = "" },
					topdelete = { text = "" },
					changedelete = { text = "▎" },
					untracked = { text = "▎" },
				},
				current_line_blame_opts = {
					delay = 0,
				},
				on_attach = function(buffer)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, desc)
						vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
					end

					map("n", "]h", gs.next_hunk, "Next Hunk")
					map("n", "[h", gs.prev_hunk, "Prev Hunk")

					map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
					map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")
					map("n", "<leader>gp", gs.preview_hunk, "Preview Hunk")
					map("n", "<leader>gd", gs.diffthis, "Diff This")
					map("n", "<leader>gD", function() gs.diffthis("~") end, "Diff This ~")
					map("n", "<leader>gb", function() gs.toggle_current_line_blame() end, "Blame Line")
				end,
			},
		},

		{
			"folke/todo-comments.nvim",
			cmd = { "TodoTrouble", "TodoTelescope" },
			event = { "BufReadPost", "BufNewFile" },
			config = true,
			-- stylua: ignore
			keys = {
				{ "]t",         function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
				{ "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
				{ "<leader>st", "<cmd>TodoTelescope<cr>",                            desc = "Todo" },
				{ "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",    desc = "Todo/Fix/Fixme" },
			},
		},

		{
			'numToStr/Comment.nvim',
			event = { "BufReadPre", "BufNewFile" },
			opts = {
				toggler = {
					line = 'gc',
					block = 'gb'
				},
				mappings = {
					extra = false
				}
			}
		},

	},
	{
		defaults = {
			lazy = true,
		},
	})
