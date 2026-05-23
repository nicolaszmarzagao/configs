return {
    "stevearc/conform.nvim",

    opts = {
        formatters_by_ft = {
            python = { "isort", "black" },
            lua = { "stylua" },

            -- Terraform
            -- terraform = { "terraform_fmt" },
            -- tf = { "terraform_fmt" },
            -- ["terraform-vars"] = { "terraform_fmt" },
        },
    },

    config = function(_, opts)
        local conform = require("conform")
        conform.setup(opts)

        vim.keymap.set("n", "<leader>f", function()
            conform.format({
                async = true,
                lsp_format = "fallback",
            })
        end, { desc = "Format file" })
    end,
}
