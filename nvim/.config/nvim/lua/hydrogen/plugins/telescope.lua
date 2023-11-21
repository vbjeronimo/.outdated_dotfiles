return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
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
      -- git
      { "<leader>gf", "<cmd>Telescope git_files<CR>" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>" },
      -- lsp
      { "gr", "<cmd>Telescope references<CR>" },
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
            ["<C-u>"] = false,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
        },
        git_files = {
          hidden = true,
        },
        oldfiles = {
          find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
        },
      },
    },
  },
}
