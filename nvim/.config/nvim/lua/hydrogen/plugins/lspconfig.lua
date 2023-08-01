return {
  {
    'neovim/nvim-lspconfig',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "folke/neodev.nvim",
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local mason = require('mason')
      local mason_lspconfig = require('mason-lspconfig')

      mason.setup({
        ui = {
          border = 'single',
          icons = {
            package_installed = '⏺',
            package_pending = '󰦗',
            package_uninstalled = '',
          }
        }
      })

      mason_lspconfig.setup({
        'bashls',
        'cssls',
        'dockerls',
        'html',
        'jsonls',
        'lua_language_server',
        'marksman',
        'pylint',
        'pyright',
        'tailwindcss',
        'taplo',
        'tsserver',
        'yamllint',
        'yamlls',
        'yapf',
      })

      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
      vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          --vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set({ "n", "v" }, "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "<leader>fb", function()
            vim.lsp.buf.format { async = true }
          end, opts)
        end
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

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
                workspace = { checkThirdParty = false },
                telemetry = { enable = false },
              },
            },
          })
        end
      })

      local signs = { Error = "", Warn = "", Hint = "", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end
  },

  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      -- "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
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
          { name = "luasnip",  group_index = 1 },
          { name = "buffer",   group_index = 2 },
          { name = "path",     group_index = 3 },
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

}
