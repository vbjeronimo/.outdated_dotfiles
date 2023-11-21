return {
  {
    "marko-cerovac/material.nvim",
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.material_style = "deep ocean"
      vim.cmd("colorscheme material")
    end,
  },

  {
    "catppuccin/nvim",
    enabled = false,
    lazy = false,
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd("colorscheme catppuccin")
    end,
  },
  {
    "rose-pine/neovim",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme rose-pine")
    end
  }
}
