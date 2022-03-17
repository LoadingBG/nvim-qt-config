require("nvim-treesitter.configs").setup {
   ensure_installed = { -- Ensure the following grammars are installed
      "css",
      "html",
      "java",
      "javascript",
      "lua",
      "query", -- TS Playground
   },
   highlight = {
      enable = true, -- Enable highlightings
   },
   autopairs = {
      enable = true, -- Enable autopairing
   },
   playground = {
      enable = true,
      updatetime = 25,
   },
}
