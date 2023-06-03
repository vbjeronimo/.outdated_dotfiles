require("hydrogen.config.options")
require("hydrogen.config.lazy")

if vim.fn.argc() == 0 then
  -- autocmds and keymaps can wait to load
  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("LazyVim", { clear = true }),
    pattern = "VeryLazy",
    callback = function()
      require("hydrogen.config.autocmds")
      require("hydrogen.config.keymaps")
    end,
  })
else
  -- load them now so they affect the opened buffers
  require("hydrogen.config.autocmds")
  require("hydrogen.config.keymaps")
end
