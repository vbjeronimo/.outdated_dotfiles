-- Make sure to set `mapleader` before lazy so your mappings are correct
vim.g.mapleader = " "

vim.opt.termguicolors = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "120"
vim.opt.wrap = false

vim.opt.list = true
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 10
vim.opt.fillchars = { eob = " " }

vim.opt.cmdheight = 1
vim.opt.laststatus = 0
vim.opt.showmode = false

vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.winminwidth = 5

vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.mouse = "a"
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.formatoptions = "jcroqlnt"
vim.opt.wildmode = "longest:full,full"
vim.opt.iskeyword:append("-")
vim.opt.hidden = true -- Enable modified buffers in background
vim.opt.confirm = true -- confirm to save changes before exiting modified buffer
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
vim.opt.spelllang = { "en" }

if vim.fn.has("nvim-0.9.0") == 1 then
  vim.opt.splitkeep = "screen"
  vim.opt.shortmess = "filnxtToOFWIcC"
end
