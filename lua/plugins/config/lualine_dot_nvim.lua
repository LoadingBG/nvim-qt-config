local mode_config = {
   ["n"]      = { name = "n",     display = "NORMAL",                             bg = "#98c379" },
   ["no"]     = { name = "no",    display = "NORMAL  Operator pending",          bg = "#98c379" },
   ["nov"]    = { name = "nov",   display = "NORMAL  CHARWISE",                  bg = "#98c379" },
   ["noV"]    = { name = "noV",   display = "NORMAL  LINEWISE",                  bg = "#98c379" },
   ["no\x16"] = { name = "noc_v", display = "NORMAL  BLOCKWISE",                 bg = "#98c379" },

   ["v"]      = { name = "v",     display = "VISUAL",                             bg = "#c678dd" },
   ["V"]      = { name = "V",     display = "VISUAL LINE",                        bg = "#c678dd" },
   ["\x16"]   = { name = "c_v",   display = "VISUAL BLOCK",                       bg = "#c678dd" },

   ["s"]      = { name = "s",     display = "SELECT",                             bg = "#56b6c2" },
   ["S"]      = { name = "S",     display = "SELECT LINE",                        bg = "#56b6c2" },
   ["\x13"]   = { name = "c_s",   display = "SELECT BLOCK",                       bg = "#56b6c2" },
   ["vs"]     = { name = "vs",    display = "SELECT  VISUAL COMMAND",            bg = "#56b6c2" },
   ["Vs"]     = { name = "Vs",    display = "SELECT LINE  VISUAL COMMAND",       bg = "#56b6c2" },
   ["\x13s"]  = { name = "c_ss",  display = "SELECT BLOCK  VISUAL COMMAND",      bg = "#56b6c2" },

   ["i"]      = { name = "i",     display = "INSERT",                             bg = "#61afef" },
   ["ic"]     = { name = "ic",    display = "INSERT  COMPLETION",                bg = "#61afef" },
   ["ix"]     = { name = "ix",    display = "INSERT  CTRL-X",                    bg = "#61afef" },
   ["niI"]    = { name = "niI",   display = "INSERT  NORMAL COMMAND",            bg = "#61afef" },

   ["R"]      = { name = "R",     display = "REPLACE",                            bg = "#e06c75" },
   ["Rc"]     = { name = "Rc",    display = "REPLACE  COMPLETION",               bg = "#e06c75" },
   ["Rx"]     = { name = "Rx",    display = "REPLACE  CTRL-X",                   bg = "#e06c75" },
   ["niR"]    = { name = "niR",   display = "REPLACE  NORMAL COMMAND",           bg = "#98c379" },
   ["Rv"]     = { name = "Rv",    display = "REPLACE  VIRTUAL",                  bg = "#e06c75" },
   ["Rvc"]    = { name = "Rvc",   display = "REPLACE  VIRTUAL  COMPLETION",     bg = "#e06c75" },
   ["Rvx"]    = { name = "Rvx",   display = "REPLACE  VIRTUAL  CTRL-X",         bg = "#e06c75" },
   ["niV"]    = { name = "niV",   display = "REPLACE  VIRTUAL  NORMAL COMMAND", bg = "#98c379" },

   ["c"]      = { name = "c",     display = "COMMAND",                            bg = "#d19a66" },
   ["cv"]     = { name = "cv",    display = "EX MODE",                            bg = "#d19a66" },
   ["!"]      = { name = "_e",    display = "SHELL",                              bg = "#d19a66" },

   ["r"]      = { name = "r",     display = "PROMPT",                             bg = "#be5046" },
   ["rm"]     = { name = "rm",    display = "PROMPT  MORE",                      bg = "#be5046" },
   ["r?"]     = { name = "r_q",   display = "PROMPT  CONFIRM",                   bg = "#be5046" },

   ["t"]      = { name = "t",     display = "TERMINAL",                           bg = "#e5c07b" },
   ["nt"]     = { name = "nt",    display = "TERMINAL  NORMAL",                  bg = "#e5c07b" },
}

for _, v in pairs(mode_config) do
   vim.cmd(string.format("hi LualineModeColor%s gui=bold,none guifg='#282c34' guibg='%s'", v.name, v.bg))
end

local function get_mode()
   local props = mode_config[vim.fn.mode()]
   return string.format("%%#LualineModeColor%s#%s", props.name, props.display)
end

local function plural_count(count, singular, plural)
   return count == 1 and "1 " .. singular or count .. " " .. plural
end

local function text_info()
   local components = {}
   table.insert(components, plural_count(vim.fn.line("$"), "line", "lines")) -- Line count
   table.insert(components, plural_count(vim.fn.wordcount().words, "word", "words")) -- Word count
   return "%#LualineModeColor" .. mode_config[vim.fn.mode()].name .. "#" .. table.concat(components, "  ")
end

require("lualine").setup {
   sections = {
      lualine_a = { get_mode },
      lualine_b = { "b:gitsigns_branch", "b:gitsigns_status", "encoding", "fileformat", "filetype" },
      lualine_c = { { "filename", symbols = { modified = " +", readonly = " " } } },
      lualine_x = { "diagnostics" },
      lualine_y = { "location", "progress" },
      lualine_z = { text_info },
   },
   options = {
      theme = dofile(vim.fn.stdpath("data") .. "/site/pack/packer/opt/lualine.nvim/lua/lualine/themes/onedark.lua")
   },
   -- TODO: see how extensions work and add one for help
   extensions = {
      "nvim-tree",
   },
}
