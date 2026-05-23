return {
	{
		"nvim-lualine/lualine.nvim",

		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},

		config = function()
			require("lualine").setup({
				options = {
					theme = "tokyonight",
					globalstatus = true,

					-- cleaner look
					component_separators = "",
					section_separators = { left = "", right = "" },

					disabled_filetypes = {
						statusline = { "NvimTree" },
					},
				},

				sections = {
					lualine_a = { "mode" },

					lualine_b = {
						"branch",
						"diff",
					},

					lualine_c = {
						{
							"filename",
							path = 1, -- 0 = filename only, 1 = relative path
							symbols = {
								modified = " ●",
								readonly = " ",
								unnamed = "[No Name]",
							},
						},
					},

					lualine_x = {
						{
							"diagnostics",
							sources = { "nvim_diagnostic" },
							symbols = {
								error = " ",
								warn = " ",
								info = " ",
								hint = "󰌵 ",
							},
						},
						"encoding",
						"filetype",
					},

					lualine_y = {
						"progress",
					},

					lualine_z = {
						"location",
					},
				},

				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {
						{
							"filename",
							path = 1,
						},
					},
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},

				extensions = {
					"nvim-tree",
					"lazy",
					"mason",
					"quickfix",
				},
			})
		end,
	},
	{
		"folke/which-key.nvim",
		opts = {},
	},

	-- Indentation guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
	},

	-- Highlight TODO, FIXME, NOTE, etc.
	{
		"folke/todo-comments.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {},
	},
}
