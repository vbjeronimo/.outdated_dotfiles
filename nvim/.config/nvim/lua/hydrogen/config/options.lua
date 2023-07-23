local opt = vim.opt
local indent = 4

vim.g.mapleader = " "
vim.g.maplocalleader = " "

opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'
opt.cursorline = true

opt.wrap = false
opt.fillchars = { eob = ' ' }
opt.list = true
opt.scrolloff = 5
opt.sidescrolloff = 10

opt.pumblend = 10
opt.pumheight = 10
opt.cmdheight = 1
opt.laststatus = 0
opt.showmode = false

opt.autoindent = true
opt.smartindent = true
opt.expandtab = true
opt.tabstop = indent
opt.shiftwidth = indent
opt.shiftround = true

opt.inccommand = "split"
opt.incsearch = true
opt.hlsearch = false
opt.ignorecase = true
opt.smartcase = true

opt.termguicolors = true
opt.splitright = true
opt.splitbelow = true
opt.winminwidth = 5

opt.backup = false
opt.swapfile = false
opt.writebackup = false
opt.autowrite = true

opt.mouse = "a"
opt.completeopt = 'menu,menuone,noselect'
opt.formatoptions = "jcroqlnt"
opt.wildmode = "longest:full,full"
opt.iskeyword:append('-')
opt.hidden = true -- Enable modified buffers in background
opt.confirm = true -- confirm to save changes before exiting modified buffer
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.spelllang = { "en" }

if vim.fn.has("nvim-0.9.0") == 1 then
  opt.splitkeep = "screen"
  opt.shortmess = "filnxtToOFWIcC"
end


