-- vim.api.nvim_create_autocmd('BufWritePre', {
-- 	pattern = '*.go',
-- 	callback = function()
-- 		vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
-- 	end
-- })

vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
  pattern = { "*.md", "*.txt" },
  callback = function()
    vim.opt.wrap = true
    vim.opt.linebreak = true
  end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufEnter" }, {
  pattern = "*.lua",
  callback = function()
    vim.opt.shiftwidth = 2
    vim.opt.tabstop = 2
  end,
})
