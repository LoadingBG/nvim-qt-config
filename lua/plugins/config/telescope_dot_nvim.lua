local telescope = require("telescope")

telescope.setup {
   extensions = {
      fzy_native = {
         override_generic_sorter = true,
         override_file_sorter = true,
      },
      --arecibo = {
      --   selected_engine = "google",
      --   url_open_command = "xdg-open",
      --   show_http_headers = false,
      --   show_domain_icons = true,
      --},
   },
}

telescope.load_extension("fzy_native")
--telescope.load_extension("arecibo")
telescope.load_extension("gh")
telescope.load_extension("file_browser")
telescope.load_extension("notify")
