return {
	"lewis6991/gitsigns.nvim",
	config = function()
		local gitsigns = require("gitsigns")

		gitsigns.setup({
			current_line_blame = false,
		})

		vim.keymap.set("n", "]h", gitsigns.next_hunk, { desc = "Next Git hunk" })
		vim.keymap.set("n", "[h", gitsigns.prev_hunk, { desc = "Previous Git hunk" })
		vim.keymap.set("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview Git hunk" })
		vim.keymap.set("n", "<leader>hb", gitsigns.blame_line, { desc = "Blame line" })
	end,
}
