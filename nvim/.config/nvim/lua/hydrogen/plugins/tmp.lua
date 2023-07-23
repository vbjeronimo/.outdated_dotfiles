return {
{
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = true,
},

{
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  opts = {
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "契" },
      topdelete = { text = "契" },
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
  'nvim-lualine/lualine.nvim',
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  event = "VeryLazy",
  opts = {
    options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = { left = '|', right = '|'},
      section_separators = { left = '', right = ''},
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
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff'},
      lualine_c = {'filename'},
      lualine_x = {'filetype'},
      lualine_y = {'diagnostics'},
      lualine_z = {'location'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {'filename'},
      lualine_x = {'location'},
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
  "aserowy/tmux.nvim",
  event = "VeryLazy",
  config = true,
},

{
  'neovim/nvim-lspconfig',
  event = "BufReadPre",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local mason = require('mason')
    local mason_lspconfig = require('mason-lspconfig')

    mason.setup({
      ui = {
        border = 'single',
        icons = {
          package_installed = '﫟',
          package_pending = '',
          package_uninstalled = '',
        }
      }
    })

    mason_lspconfig.setup({
      'astro',
      'bashls',
      'cssls',
      'html',
      'jsonls',
      'lua_language_server',
      'marksman',
      'pylint',
      'pyright',
      'tailwindcss',
      'tsserver',
      'yamlls',
      'yapf',
      'yamllint'
    })

    vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set({"n", "v"}, "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>f", function()
          vim.lsp.buf.format { async = true }
        end, opts)
      end
    })

    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local lspconfig = require('lspconfig')

    mason_lspconfig.setup_handlers({
      function(server_name)
        lspconfig[server_name].setup({
          on_attach = on_attach,
          capabilities = capabilities
        })
      end,
      ["lua_ls"] = function()
          lspconfig["lua_ls"].setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { "vim" } },
                workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                telemetry = { enable = false }
              }
            }
          })
      end
    })

    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
  end
},

{
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim"
  },
  cmd = "Telescope",
  keys = {
    { "<leader>:", "<cmd>Telescope command_history<CR>" },
    -- find
    { "<leader>ff", "<cmd>Telescope find_files<CR>" },
    { "<leader>fo", "<cmd>Telescope oldfiles<CR>" },
    -- search
    { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<CR>" },
    { "<leader>sh", "<cmd>Telescope help_tags<CR>" },
    { "<leader>sg", "<cmd>Telescope live_grep<CR>" },
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
  "hrsh7th/nvim-cmp",
  version = false,
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "saadparwaiz1/cmp_luasnip",
    "onsails/lspkind.nvim",
    "ray-x/lsp_signature.nvim"
  },
  config = function()
    local cmp = require("cmp")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local lspkind = require("lspkind")
    local lsp_signature = require("lsp_signature")

    lsp_signature.setup({
        hint_enable = false,
        handler_opts = {
            border = "single"
        }
    })

    cmp.setup({
        enabled = function()
            -- disable completion in comments
            local context = require "cmp.config.context"
            -- keep command mode completion enabled when cursor is in a comment
            if vim.api.nvim_get_mode().mode == "c" then
                return true
            elseif vim.bo.buftype == "prompt" then
                return false
            else
                return not context.in_treesitter_capture("comment")
                    and not context.in_syntax_group("Comment")
            end
        end
        ,
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        window = {
            completion = {
                border = 'single',
                winhighlight = "FloatBorder:FloatBorder,Normal:Normal",
            },
            documentation = {
                border = 'single',
                winhighlight = "FloatBorder:FloatBorder,Normal:Normal",
            },
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<C-CR>"] = cmp.mapping.confirm({ select = false }),
        }),
        sources = {
            { name = "nvim_lsp", group_index = 1 },
            { name = "nvim_lua", group_index = 1 },
            { name = "luasnip", group_index = 1 },
            { name = "buffer", group_index = 2 },
            { name = "path", group_index = 3 },
        },
        formatting = {
            format = lspkind.cmp_format({
                mode = "symbol_text",
                maxwidth = 50,
                ellipsis_char = "...",
                menu = ({
                    buffer = "[Buffer]",
                    nvim_lsp = "[LSP]",
                    luasnip = "[LuaSnip]",
                    nvim_lua = "[Lua]",
                    path = "[Path]",
                })
            })
        }
    })

    cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer" }
        }
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" }
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" }
          }
        }
      })
    })

    cmp.event:on(
        "confirm_done",
        cmp_autopairs.on_confirm_done()
    )
  end,
},

{
  "nvim-tree/nvim-tree.lua",
  dependencies = {
      "nvim-tree/nvim-web-devicons"
  },
  opts = {
    view = {
      width = 30,
      mappings = {
        list = {
          -- user mappings go here
        },
      },
    },
    diagnostics = {
      enable = true,
    },
    update_focused_file = {
      enable = true,
    },
    actions = {
      open_file = {
        quit_on_open = true,
      },
    },
  },
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<CR>" }
  }
},

{
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  keys = {
    { "<C-space>", desc = "Increment selection" },
    { "<BS>", desc = "Schrink selection", mode = "x" },
  },
  config = function ()
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
    })
  end
},

{
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons"
  },
  opts = {
    view = {
      width = 30,
      mappings = {
        list = {
          -- user mappings go here
        },
      },
    },
    diagnostics = {
      enable = true,
    },
    update_focused_file = {
      enable = true,
    },
    actions = {
      open_file = {
        quit_on_open = true,
      },
    },
  },
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<CR>" }
  }
},

{
  "phaazon/hop.nvim",
  branch = "v2",
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
  "folke/todo-comments.nvim",
  cmd = { "TodoTrouble", "TodoTelescope" },
  event = { "BufReadPost", "BufNewFile" },
  config = true,
  -- stylua: ignore
  keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
    --{ "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
    --{ "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
    { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
  },
},

{
  "jose-elias-alvarez/null-ls.nvim",
  enabled = false,
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "mason.nvim" },
  opts = function()
    local nls = require("null-ls")
    return {
      sources = {
        --nls.builtins.formatting.prettierd,
        nls.builtins.formatting.yapf,
        nls.builtins.diagnostics.pylint,
        nls.builtins.diagnostics.yamllint,
      },
    }
  end
},

{
  "kylechui/nvim-surround",
  version = "*", -- Use for stability; omit to use `main` branch for the latest features
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup({
      -- Configuration here, or leave empty to use defaults
    })
  end
},

}
