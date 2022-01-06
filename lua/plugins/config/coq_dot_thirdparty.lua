require("coq_3p") {
   {
      src = "nvimlua",
      short_name = "NVIM",
      conf_only = true,
   },
   {
      src = "repl",
      sh = "powershell",
      shell = { node = "node", jshell = "jshell" },
      max_lines = 99,
      deadline = 500,
      unsafe = { "rm", "poweroff", "mv" },
   },
   {
      src = "copilot",
      shor_name = "COP",
      accept_key = "<Leader>cop",
   },
}
