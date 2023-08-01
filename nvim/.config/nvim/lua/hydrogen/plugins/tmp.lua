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
    "aserowy/tmux.nvim",
    event = "VeryLazy",
    config = true,
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
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        sources = {
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
    config = true
  },

  {
    'lukas-reineke/indent-blankline.nvim',
    opts = {
      -- char = '⏐',
      show_trailing_blankline_indent = false,
    },
  },

  {
    'numToStr/Comment.nvim',
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

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    keys = {
      { "<leader>co", "<cmd>lua require('copilot.suggestion').toggle_auto_trigger()<cr>", desc = "Toggle Copilot" },
    },
    opts = {
      suggestion = {
        auto_trigger = false,
        keymap = {
          accept = "<C-f>",
          accept_line = "<C-y>",
          decline = "<C-e>",
          next = "<C-n>",
          prev = "<C-p>",
        },
      },
    },
  },

}
