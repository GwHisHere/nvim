local M = {}

function M.plugins(use)
    -- Motions
    use {
        "ggandor/leap.nvim",
        requires = {
            {
                "ggandor/flit.nvim",
                keys = { "f", "F", "t", "T" },
                config = [[require("flit").setup()]],
            },
        },
        keys = { "s", "S" },
        config = [[require("leap").add_default_mappings()]],
    }

    -- LSP Support // I'm just downloading everything :)
    use { "neovim/nvim-lspconfig", opt = true }
    use { "jose-elias-alvarez/null-ls.nvim", opt = true }
    use { "williamboman/mason.nvim", opt = true }
    use { "williamboman/mason-lspconfig.nvim", opt = true }
    use { "jay-babu/mason-null-ls.nvim", opt = true }
    use { "j-hui/fidget.nvim", opt = true }

    -- LSP Additionals // Not lazyloaded yet
    use { "ThePrimeagen/refactoring.nvim" }
    use { "b0o/SchemaStore.nvim", opt = true }
    -- use { "simrat39/rust-tools.nvim", ft = "rust" }

    -- Snippets
    use { "L3MON4D3/LuaSnip", opt = true }
    use { "rafamadriz/friendly-snippets" } -- No need for lazyloading

    -- Autocompletion
    use {
        "hrsh7th/nvim-cmp",
        requires = {
            { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp-signature-help", after = "nvim-cmp" },
            { "saadparwaiz1/cmp_luasnip", after = "cmp-nvim-lsp-signature-help" },
            { "hrsh7th/cmp-nvim-lua", after = "cmp_luasnip" },
            { "hrsh7th/cmp-path", after = "cmp-nvim-lua" },
            { "hrsh7th/cmp-buffer", after = "cmp-path" },
            { "lukas-reineke/cmp-under-comparator", opt = true },
            { "onsails/lspkind.nvim", opt = true },
        },
        event = "InsertEnter",
        wants = "LuaSnip",
        config = [[require "config.cmp"]],
    }

    -- Commenting
    use {
        "numToStr/Comment.nvim",
        requires = {
            {
                "JoosepAlviste/nvim-ts-context-commentstring",
                module = "ts_context_commentstring",
            },
        },
        keys = {
            { "n", "gcc" },
            { "n", "gbc" },
            { "v", "gc" },
            { "v", "gb" },
        },
        config = function()
            require("Comment").setup {
                ignore = "^$", -- ignore empty lines
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            }
        end,
    }

    -- Colorizer
    use {
        "NvChad/nvim-colorizer.lua",
        ft = { "css", "javascript", "vim", "html", "latex", "tex" },
        config = [[require("colorizer").setup()]],
    }

    -- Telescope
    use {
        "nvim-telescope/telescope.nvim",
        requires = { "nvim-telescope/telescope-fzy-native.nvim", opt = true },
        wants = "telescope-fzy-native.nvim",
        cmd = "Telescope",
        config = [[require("config.telescope")]],
    }

    -- Treesitter
    use {
        "nvim-treesitter/nvim-treesitter",
        event = "BufRead",
        run = ":TSUpdate",
        config = [[require("config.treesitter")]],
    }

    -- Utils
    use {
        "ojroques/nvim-bufdel",
        cmd = "BufDel",
        config = [[require("bufdel").setup()]],
    }

    use {
        "monkoose/matchparen.nvim",
        after = "nvim-treesitter",
        config = [[require("matchparen").setup()]],
    }

    use {
        "kylechui/nvim-surround",
        -- keys = { "ys", "ds", "cs" },
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup {
                -- Configuration here, or leave empty to use defaults
            }
        end,
    }
    use { "windwp/nvim-autopairs", opt = true }

    use {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        config = [[vim.g.undotree_SetFocusWhenToggle = 1]],
    }

    -- Colorscheme
    use {
        "ellisonleao/gruvbox.nvim",
        config = [[vim.cmd.colorscheme "gruvbox"]],
        after = "nvim-treesitter",
    }

    -- Profiler
    use {
        "dstein64/vim-startuptime",
        cmd = "StartupTime",
    }
end

return M
