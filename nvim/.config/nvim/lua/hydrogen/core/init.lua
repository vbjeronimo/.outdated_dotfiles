local function load_module(module_name)
  local ok, err = pcall(require, module_name)
  if not ok then
    error(("Error loading module %s...\n\n%s"):format(module_name, err))
  end
end

load_module("hydrogen.core.options")
load_module("hydrogen.core.lazy")

if vim.fn.argc() == 0 then
  -- autocmds and keymaps can wait to load
  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("LazyVim", { clear = true }),
    pattern = "VeryLazy",
    callback = function()
      load_module("hydrogen.core.autocmds")
      load_module("hydrogen.core.keymaps")
    end,
  })
else
  -- load them now so they affect the opened buffers
  load_module("hydrogen.core.autocmds")
  load_module("hydrogen.core.keymaps")
end
