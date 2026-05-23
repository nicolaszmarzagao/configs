return {
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		lazy = false,
		config = function()
			require("nvim-tree").setup({
				disable_netrw = true,
				hijack_netrw = true,

				view = {
					width = 30,
				},

				renderer = {
					group_empty = true,
				},
			})

			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function(data)
					local is_directory = vim.fn.isdirectory(data.file) == 1

					if not is_directory then
						return
					end

					vim.cmd.cd(data.file)
					require("nvim-tree.api").tree.open()
				end,
			})
		end,
		keys = {
			{ "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
		},
	},
}
