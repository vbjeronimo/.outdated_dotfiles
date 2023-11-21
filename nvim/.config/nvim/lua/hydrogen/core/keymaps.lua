vim.keymap.set({ "n", "i", "v" }, "<M-Space>", "<Esc>", { desc = "Same as <Esc>" })

vim.keymap.set("n", "x", '"_x', { desc = "Don't yank with 'x'" })
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to the system's clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to the system's clipboard" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Better scroll down motion" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Better scroll up motion" })

vim.keymap.set("v", "<", "<gv", { desc = "Indent block to the left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent block to the right" })

vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to the window below" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to the window on the left" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to the window on the right" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to the window above" })
