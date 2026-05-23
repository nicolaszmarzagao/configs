vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })

vim.keymap.set("n", "<leader>l", ":Lazy<CR>", { desc = "Open Lazy" })
vim.keymap.set("n", "<leader>m", ":Mason<CR>", { desc = "Open Mason" })

vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file tree" })
vim.keymap.set("n", "<leader>E", ":NvimTreeFindFile<CR>", { desc = "Find current file in tree" })

vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlight" })

vim.keymap.set("n", "<leader>j", function()
	vim.cmd("botright split")
	vim.cmd("resize 10")
	vim.cmd("terminal")
end, { desc = "Open terminal" })
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
