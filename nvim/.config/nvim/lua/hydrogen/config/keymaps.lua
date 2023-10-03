local map = vim.keymap.set

-- don't yank with 'x'
map('n', 'x', '"_x')

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

map("i", "<C-BS>", "<Esc>ciw", { desc = "Delete word" })

-- Lazy
map("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "Open Lazy" })

-- Mason
map("n", "<leader>m", "<cmd>:Mason<cr>", { desc = "Open Mason" })

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- experimental
map("n", "<leader>wc", "<cmd>source /home/vitor/projects/colors.lua<cr><cmd>lua print('done')<cr>", { desc = "Export colorscheme" })
