return {
	{
		"mason-org/mason.nvim",
		lazy = false,
		opts = {
			ui = {
				border = "rounded",
			},
		},
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			"mason-org/mason.nvim",
		},
		opts = {
			ensure_installed = {
				-- Python
				"pyright",
				"ruff",
				"black",
				"isort",

				-- Lua
				"lua-language-server",
				"stylua",

				-- Terraform
				-- "terraform-ls",
				-- "terraform",
			},
			auto_update = false,
			run_on_start = true,
		},
	},
}
