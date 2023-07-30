return {
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
}
