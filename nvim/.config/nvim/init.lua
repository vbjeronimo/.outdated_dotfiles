-- INITIAL SETUP
-- Keep this at the top of the config
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- OPTIONS
-- Example using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

vim.opt.termguicolors = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.wrap = false

vim.opt.fillchars = { eob = ' ' }


-- KEYMAPS
vim.keymap.set({'n', 'i', 'v'}, '<M-Space>', '<Esc>', {desc='Same as <Esc>'})

vim.keymap.set('n', 'x', '"_x', {desc="Don't yank with 'x'"})
vim.keymap.set({'n', 'v'}, '<leader>y', '"+y', {desc="Yank to the system's clipboard"})
vim.keymap.set('n', '<leader>Y', '"+Y', {desc="Yank line to the system's clipboard"})

vim.keymap.set("v", "<", "<gv", {desc='Indent block to the left'})
vim.keymap.set("v", ">", ">gv", {desc='Indent block to the right'})

vim.keymap.set('n', '<C-j>', '<C-w>j', {desc='Move to the window below'})
vim.keymap.set('n', '<C-h>', '<C-w>h', {desc='Move to the window on the left'})
vim.keymap.set('n', '<C-l>', '<C-w>l', {desc='Move to the window on the right'})
vim.keymap.set('n', '<C-k>', '<C-w>k', {desc='Move to the window above'})


-- PLUGINS
require("lazy").setup({
  {
    "marko-cerovac/material.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.material_style = "deep ocean"
      vim.cmd("colorscheme material")
    end
  }, 
})
