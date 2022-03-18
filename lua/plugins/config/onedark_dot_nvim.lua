local onedark = require("onedark")

onedark.setup {
   style = "dark",
   toggle_style_key = "<Leader>st",
   code_style = {
      comments = "italic",
      keywords = "bold",
      functions = "none",
      strings = "none",
      variables = "none",
   },
   highlights = {
      TSKeywordFunction = { fmt = "bold" },
   },
   diagnostics = {
      darker = true,
      undercurl = true,
      background = true,
   },
}

onedark.load()
