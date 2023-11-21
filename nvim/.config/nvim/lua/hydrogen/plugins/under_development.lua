return {
  {
    dir = "~/projects/palette.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    enabled = true,
    event = "VeryLazy",
    config = function()
      local palette = require("palette")

      palette.setup({
        auto_generate = true,
        output_files = {
          xresources = {
            enabled = true,
            -- path = "$HOME/.Xresources",
            path = "~/projects/palette.nvim/tests/.Xresources",
          },
          kitty = {
            enabled = true,
            -- path = "$HOME/.config/kitty/colors.conf",
            path = "$HOME/projects/palette.nvim/tests/kitty.conf",
          },
        },
      })

      vim.keymap.set("n", "<leader>dp", function()
        package.loaded.palette = nil
        require("palette")
        vim.print("Palette module reloaded.")
      end, { desc = "(Dev) Reload Palette" })
    end,
  },
}
