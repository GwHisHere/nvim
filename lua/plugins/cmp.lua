local M = {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        -- For cmp
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "lukas-reineke/cmp-under-comparator",
        "onsails/lspkind.nvim",

        -- Snippets
        {
            "L3MON4D3/LuaSnip",
            dependencies = {
                "rafamadriz/friendly-snippets",
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end,
            },
        },
    },
    config = function()
        local luasnip = require "luasnip"

        luasnip.config.setup {
            history = true,
            enable_autosnippets = true,
            region_check_events = "InsertEnter",
            delete_check_events = "InsertEnter",
        }

        local cmp = require "cmp"
        local types = require "cmp.types"
        local context = require "cmp.config.context"

        cmp.setup {
            preselect = types.cmp.PreselectMode.None,
            enabled = function()
                if vim.bo.buftype == "prompt" then
                    return false
                end
                -- Disable completion in comments
                -- Keep command mode completion enabled when cursor is in a comment
                if vim.api.nvim_get_mode().mode == "c" then
                    return true
                else
                    return not context.in_treesitter_capture "comment" and not context.in_syntax_group "Comment"
                end
            end,
            completion = {
                completeopt = "menu,menuone,noinsert",
            },
            sorting = {
                comparators = {
                    cmp.config.compare.offset,
                    cmp.config.compare.exact,
                    cmp.config.compare.score,
                    require("cmp-under-comparator").under,
                    cmp.config.compare.kind,
                    cmp.config.compare.sort_text,
                    cmp.config.compare.length,
                    cmp.config.compare.order,
                },
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            sources = cmp.config.sources({
                { name = "nvim_lua", keyword_length = 3 },
                { name = "nvim_lsp", keyword_length = 3 },
                { name = "nvim_lsp_signature_help" },
                { name = "luasnip", keyword_length = 2 },
                { name = "path" },
            }, {
                { name = "buffer", keyword_length = 3 },
            }),
            confirmation = { default_behavior = types.cmp.ConfirmBehavior.Replace },
            window = {
                documentation = vim.tbl_deep_extend("force", cmp.config.window.bordered(), {
                    max_height = 15,
                    max_width = 60,
                }),
                completion = vim.tbl_deep_extend("force", cmp.config.window.bordered(), {
                    col_offset = -3,
                    side_padding = 0,
                }),
            },
            formatting = {
                fields = { "kind", "abbr", "menu" },
                format = function(entry, vim_item)
                    local kind = require("lspkind").cmp_format { mode = "symbol_text", maxwidth = 50 }(entry, vim_item)
                    local strings = vim.split(kind.kind, "%s", { trimempty = true })
                    local word = entry:get_insert_text()
                    if entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet then
                        word = vim.lsp.util.parse_snippet(word)
                    end
                    kind.kind = " " .. strings[1] .. " "
                    kind.menu = "[" .. strings[2] .. "]"
                    if
                        entry.completion_item.insertTextFormat == types.lsp.InsertTextFormat.Snippet
                        and string.sub(kind.abbr, -1, -1) == "~"
                    then
                        word = word .. "~"
                    end
                    kind.abbr = word
                    return kind
                end,
            },
            mapping = {
                -- complete selection
                ["<C-Space>"] = cmp.mapping.complete(),
                -- confirm selection
                ["<CR>"] = cmp.mapping.confirm {
                    behavior = types.cmp.ConfirmBehavior.Replace,
                    select = true,
                },
                -- Super Tab Next
                ["<Tab>"] = cmp.mapping(function(fallback)
                    local col = vim.fn.col "." - 1
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif col == 0 or vim.fn.getline("."):sub(col, col):match "%s" then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                -- Super Tab Previes
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            },
            experimental = { ghost_text = true },
        }
        cmp.event:on(
            "confirm_done",
            require("nvim-autopairs.completion.cmp").on_confirm_done { map_char = { tex = "" } }
        ) -- autopairs with cmp
    end,
}
return M
