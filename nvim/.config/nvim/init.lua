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
-- Example using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

vim.opt.termguicolors = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false

vim.opt.fillchars = { eob = ' ' }


-- KEYMAPS
vim.keymap.set({ 'n', 'i', 'v' }, '<M-Space>', '<Esc>', { desc = 'Same as <Esc>' })

vim.keymap.set('n', 'x', '"_x', { desc = "Don't yank with 'x'" })
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = "Yank to the system's clipboard" })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = "Yank line to the system's clipboard" })

vim.keymap.set("v", "<", "<gv", { desc = 'Indent block to the left' })
vim.keymap.set("v", ">", ">gv", { desc = 'Indent block to the right' })

vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to the window below' })
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to the window on the left' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to the window on the right' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to the window above' })


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
                require("mason-lspconfig").setup_handlers({
                    function(server_name)
                        require("lspconfig")[server_name].setup({
                            capabilities = capabilities
                        })
                    end,
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
                        ['<C-p>'] = cmp.mapping.select_prev_item(),
                        ['<C-n>'] = cmp.mapping.select_next_item(),
                        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                        ['<C-f>'] = cmp.mapping.scroll_docs(4),
                        ['<C-Space>'] = cmp.mapping.complete(),
                        ['<C-e>'] = cmp.mapping.abort(),
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

    },
    {
        defaults = {
            lazy = true,
        },
    })
