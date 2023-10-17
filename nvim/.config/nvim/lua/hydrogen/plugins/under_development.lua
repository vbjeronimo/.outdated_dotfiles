return {
  {
    dir = "~/projects/palette.nvim",
    event = "VeryLazy",
    config = function()
      local palette = require("palette")

      palette.setup({
        output_files = {
          xresources = {
            enabled = true,
            -- path = "/home/vitor/projects/palette.nvim/palette-tests/.Xresources",
            path = "$HOME/.Xresources",
          },
          kitty = {
            enabled = true,
            -- path = "$HOME/projects/palette.nvim/palette-tests/kitty.conf",
            path = "$HOME/.config/kitty/colors.conf",
          },
          test = {
            enabled = true,
            path = "$HOME/projects/palette.nvim/palette-tests/this-dir-shouldnt-exist/test.conf",
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
