return {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    dependencies = {
        "echasnovski/mini.indentscope",
        config = function()
            require("mini.indentscope").setup {
                draw = {
                    delay = 50,
                },
            }
        end,
    },
    config = {
        char = "│",
        use_treesitter_scope = false,
        show_trailing_blankline_indent = false,
        -- show_current_context = true,
        space_char_blankline = " ",
        use_treesitter = true,
        show_first_indent_level = false,
        buftype_exclude = { "terminal", "nofile" },
        filetype_exclude = {
            "norg",
            "alpha",
            "help",
            "neogitstatus",
            "neo-tree",
            "lazy",
            "Telescope",
        },
        context_patterns = {
            "^for",
            "^func",
            "^if",
            "^object",
            "^table",
            "^while",
            "argument_list",
            "arguments",
            "block",
            "catch_clause",
            "class",
            "dictionary",
            "do_block",
            "element",
            "else_clause",
            "except",
            "for",
            "function",
            "if_statement",
            "import_statement",
            "method",
            "object",
            "operation_type",
            "return",
            "table",
            "try",
            "try_statement",
            "tuple",
            "while",
            "with",
        },
    },
}
