-- ===== Nicolas Neovim config: one-file setup =====
-- No Treesitter version, to avoid nvim-treesitter.configs errors.

-- ===== Leader key =====
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local has_nvim_011 = vim.fn.has("nvim-0.11") == 1

-- ===== Bootstrap lazy.nvim =====
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop

if not uv.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"

    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})

        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)

-- ===== Plugins =====
require("lazy").setup({
    -- Theme
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            style = "night",
            transparent = true,
            terminal_colors = true,
            styles = {
                sidebars = "transparent",
                floats = "transparent",
            },
        },
        config = function(_, opts)
            require("tokyonight").setup(opts)
            vim.cmd.colorscheme("tokyonight-night")
        end,
    },

    -- File tree
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            require("nvim-tree").setup({
                view = {
                    width = 35,
                    side = "left",
                },
                renderer = {
                    group_empty = true,
                    icons = {
                        show = {
                            file = true,
                            folder = true,
                            folder_arrow = true,
                            git = true,
                        },
                    },
                },
                filters = {
                    dotfiles = false,
                },
                update_focused_file = {
                    enable = true,
                    update_root = false,
                },
            })
        end,
    },

    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local telescope = require("telescope")
            local builtin = require("telescope.builtin")

            telescope.setup({
                defaults = {
                    file_ignore_patterns = {
                        "node_modules",
                        ".git/",
                        "__pycache__",
                        ".venv/",
                        "venv/",
                        "dist/",
                        "build/",
                    },
                },
            })

            vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
            vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Search text" })
            vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
            vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
        end,
    },

    -- Statusline
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
                },
            })
        end,
    },

    -- Git signs in gutter
    {
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
    },

    -- Shows available keybinds
    {
        "folke/which-key.nvim",
        opts = {},
    },

    -- Mason: installs LSP servers, formatters, linters, debuggers
    {
        "mason-org/mason.nvim",
        lazy = false,
        opts = {
            ui = {
                border = "rounded",
            },
        },
    },

    -- Auto-install useful Python/Lua tools
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = {
            "mason-org/mason.nvim",
        },
        opts = {
            ensure_installed = {
                "pyright",
                "ruff",
                "black",
                "isort",
                "debugpy",
                "lua-language-server",
                "stylua",
            },
            auto_update = false,
            run_on_start = true,
        },
    },

    -- LSP config: Python + Lua
    {
        "neovim/nvim-lspconfig",
        enabled = has_nvim_011,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            vim.diagnostic.config({
                virtual_text = {
                    prefix = "●",
                },
                signs = true,
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = {
                    border = "rounded",
                },
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(event)
                    local map = function(mode, lhs, rhs, desc)
                        vim.keymap.set(mode, lhs, rhs, {
                            buffer = event.buf,
                            desc = desc,
                        })
                    end

                    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
                    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
                    map("n", "gr", vim.lsp.buf.references, "Find references")
                    map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
                    map("n", "K", vim.lsp.buf.hover, "Hover documentation")
                    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
                    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
                    map("n", "<leader>d", vim.diagnostic.open_float, "Line diagnostics")
                    map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
                    map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")

                    local client = vim.lsp.get_client_by_id(event.data.client_id)

                    -- Let Pyright handle hover docs instead of Ruff.
                    if client and client.name == "ruff" then
                        client.server_capabilities.hoverProvider = false
                    end
                end,
            })

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

            vim.lsp.enable({
                "pyright",
                "ruff",
                "lua_ls",
            })
        end,
    },

    -- Autocomplete
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },

                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),

                    ["<CR>"] = cmp.mapping.confirm({
                        select = false,
                    }),

                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                }),

                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                    { name = "buffer" },
                }),
            })
        end,
    },

    -- Formatter
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                python = { "isort", "black" },
                lua = { "stylua" },
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
    },

    -- Python debugger
    {
        "mfussenegger/nvim-dap-python",
        ft = "python",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        config = function()
            local debugpy_python = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"

            if vim.fn.executable(debugpy_python) == 1 then
                require("dap-python").setup(debugpy_python)
            else
                print("debugpy is not installed yet. Run :MasonInstall debugpy")
            end

            local dap = require("dap")

            vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP continue" })
            vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP step over" })
            vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP step into" })
            vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP step out" })
            vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
        end,
    },

    -- Autopairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },

    -- Comment/uncomment with gcc or gc
    {
        "numToStr/Comment.nvim",
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
}, {
    checker = {
        enabled = true,
    },
    install = {
        colorscheme = { "tokyonight" },
    },
})

-- ===== Basics =====
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true

vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.background = "dark"

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

vim.opt.updatetime = 250
vim.opt.timeoutlen = 400

vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.cmd([[syntax on]])
vim.cmd([[filetype plugin indent on]])

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- ===== Helper functions =====
local function get_project_root()
    local current_file_dir = vim.fn.expand("%:p:h")

    local markers = vim.fs.find({
        ".git",
        "pyproject.toml",
        "setup.py",
        "requirements.txt",
    }, {
        path = current_file_dir,
        upward = true,
    })

    if markers[1] then
        return vim.fn.fnamemodify(markers[1], ":h")
    end

    return vim.fn.getcwd()
end

local function get_python_command()
    local root = get_project_root()
    local venv_python = root .. "/.venv/bin/python"

    if vim.fn.executable(venv_python) == 1 then
        return venv_python
    end

    return "python3"
end

-- ===== Keymaps =====
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })

-- Reload Neovim config
vim.keymap.set("n", "<leader>sv", ":source ~/.config/nvim/init.lua<CR>", { desc = "Reload config" })

-- Lazy plugin manager
vim.keymap.set("n", "<leader>l", ":Lazy<CR>", { desc = "Open Lazy" })

-- Mason tool manager
vim.keymap.set("n", "<leader>m", ":Mason<CR>", { desc = "Open Mason" })

-- File tree
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file tree" })
vim.keymap.set("n", "<leader>E", ":NvimTreeFindFile<CR>", { desc = "Find current file in tree" })

-- Clear search highlight
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- Simple build & run for C projects using Makefile
vim.keymap.set("n", "<leader>r", function()
    vim.cmd("w")
    vim.cmd("!make && ./main")
end, { desc = "Build & run C project" })

-- Run current Python file
vim.keymap.set("n", "<leader>rp", function()
    if vim.bo.filetype ~= "python" then
        print("This is not a Python file.")
        return
    end

    vim.cmd("w")

    local python_cmd = get_python_command()
    local file = vim.fn.expand("%:p")

    vim.cmd("botright split")
    vim.cmd("resize 15")
    vim.cmd("terminal " .. vim.fn.shellescape(python_cmd) .. " " .. vim.fn.shellescape(file))
end, { desc = "Run Python file" })

-- Open terminal
vim.keymap.set("n", "<leader>tt", function()
    vim.cmd("botright split")
    vim.cmd("resize 15")
    vim.cmd("terminal")
end, { desc = "Open terminal" })

-- Easier terminal exit: press Esc in terminal mode
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- ===== Markdown clean view =====
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.conceallevel = 2
        vim.opt_local.concealcursor = "nc"
        vim.opt_local.spell = true
        vim.opt_local.textwidth = 80

        vim.keymap.set("n", "j", "gj", { buffer = true, desc = "Move down visual line" })
        vim.keymap.set("n", "k", "gk", { buffer = true, desc = "Move up visual line" })

        vim.keymap.set("n", "<leader>ms", function()
            vim.opt_local.spell = not vim.opt_local.spell:get()
            print("Spell check: " .. tostring(vim.opt_local.spell:get()))
        end, { buffer = true, desc = "Toggle Markdown spell check" })

        vim.keymap.set("n", "<leader>mw", function()
            vim.opt_local.wrap = not vim.opt_local.wrap:get()
            print("Wrap: " .. tostring(vim.opt_local.wrap:get()))
        end, { buffer = true, desc = "Toggle Markdown wrap" })
    end,
})

-- ===== Glow Markdown preview =====
vim.keymap.set("n", "<leader>mg", function()
    local file = vim.fn.expand("%:p")

    if vim.bo.filetype ~= "markdown" then
        print("This is not a Markdown file.")
        return
    end

    if vim.fn.executable("glow") == 0 then
        print("Glow is not installed.")
        return
    end

    vim.cmd("w")
    vim.cmd("botright split")
    vim.cmd("resize 18")
    vim.cmd("terminal glow " .. vim.fn.shellescape(file))
end, { desc = "Preview Markdown with Glow" })
