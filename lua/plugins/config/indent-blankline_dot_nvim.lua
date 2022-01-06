require("indent_blankline").setup {
   use_treesitter = true,
   show_current_context = true,
   show_current_context_start = true,
   context_char = "┃",
   context_patterns = {
      "class", "function", "method", "block", "list_literal", "selector",
      "^if", "^table", "if_statement", "while", "for",
   },

   max_indent_increase = 1,
   show_trailing_blankline_indent = false,

   filetype_exclude = { "help", "terminal", "packer", "NvimTree", "lsp-install", "checkhealth" },
   buftype_exclude = { "terminal" },
}
