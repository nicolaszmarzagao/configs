local has_nvim_011 = vim.fn.has("nvim-0.11") == 1

return {
    "neovim/nvim-lspconfig",

    enabled = has_nvim_011,

    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
    },

    config = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
        capabilities.general = capabilities.general or {}
	    capabilities.general.positionEncodings = { "utf-16" }

        vim.lsp.config("pyright", {
            capabilities = capabilities,
            settings = {
                python = {
                    analysis = {
                        typeCheckingMode = "basic",
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                    },
                },
            },
        })

        vim.lsp.config("ruff", {
            capabilities = capabilities,
        })

        vim.lsp.config("lua_ls", {
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                    workspace = {
                        checkThirdParty = false,
                    },
                },
            },
        })

        -- Terraform
        -- Uncomment this when you install terraform-ls with Mason.
        -- vim.lsp.config("terraformls", {
        --     capabilities = capabilities,
        -- })

        vim.lsp.enable({
            "pyright",
            "ruff",
            "lua_ls",

            -- Terraform
            -- "terraformls",
        })
    end,
}
