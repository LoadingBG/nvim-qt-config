-- see `:h nvim-tree-options`
vim.g.nvim_tree_highlight_opened_files = 2
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_quit_on_open = 1
vim.g.nvim_tree_indent_markers = 1
vim.g.nvim_tree_add_trailing = 1
vim.g.nvim_tree_group_empty = 1
vim.g.nvim_tree_special_files = {
   ["Cargo.toml"] = true,
   ["Makefile"] = true,
   ["README.md"] = true,
   ["readme.md"] = true,

   ["pom.xml"] = true,
   ["build.gradle"] = true,
}

-- See `:h nvim-tree.disable_netrw`
require("nvim-tree").setup {
   hijack_cursor = true,
   diagnostics = {
      enable = true,
   },
   view = {
      auto_resize = true,
   },
   git = {
      enable = true,
   },
}
