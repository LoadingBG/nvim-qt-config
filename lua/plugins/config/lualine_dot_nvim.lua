local lualine = require("lualine")
local ts_utils = require("nvim-treesitter.ts_utils")

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
   ["vs"]     = { name = "vs",    display = "SELECT  VISUAL COMMAND",            bg = "#c678dd" },
   ["Vs"]     = { name = "Vs",    display = "SELECT LINE  VISUAL COMMAND",       bg = "#c678dd" },
   ["\x13s"]  = { name = "c_ss",  display = "SELECT BLOCK  VISUAL COMMAND",      bg = "#c678dd" },

   ["i"]      = { name = "i",     display = "INSERT",                             bg = "#61afef" },
   ["ic"]     = { name = "ic",    display = "INSERT  COMPLETION",                bg = "#61afef" },
   ["ix"]     = { name = "ix",    display = "INSERT  CTRL-X",                    bg = "#61afef" },
   ["niI"]    = { name = "niI",   display = "INSERT  NORMAL COMMAND",            bg = "#98c379" },

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

--local function plural_count(count, singular, plural)
--   return count == 1 and "1 " .. singular or count .. " " .. plural
--end
--
--local function text_info()
--   local components = {}
--   table.insert(components, plural_count(vim.fn.line("$"), "line", "lines")) -- Line count
--   table.insert(components, plural_count(vim.fn.wordcount().words, "word", "words")) -- Word count
--   return "%#LualineModeColor" .. mode_config[vim.fn.mode()].name .. "#" .. table.concat(components, " " .. lualine.get_config().options.component_separators.right .. " ")
--end

local function named_definition(symbol, name_group)
   return function(node)
      for _, child in ipairs(ts_utils.get_named_children(node)) do
         if child:type() == name_group then
            return symbol .. " " .. ts_utils.get_node_text(child)[1]
         end
      end
   end
end

-- TODO: improve this function
local function java_anonymous_class(symbol)
   return function(node)
      local is_anonymous
      for _, child in ipairs(ts_utils.get_named_children(node)) do
         if child:type() == "class_body" then
            is_anonymous = true
         end
      end
      if not is_anonymous then
         return
      end
      for _, child in ipairs(ts_utils.get_named_children(node)) do
         if child:type() == "type_identifier" then
            return symbol .. " " .. ts_utils.get_node_text(child)[1]
         elseif child:type() == "generic_type" then
            for _, grandchild in ipairs(ts_utils.get_named_children(child)) do
               if grandchild:type() == "type_identifier" then
                  return symbol .. " " .. ts_utils.get_node_text(grandchild)[1]
               end
            end
         --elseif child:type()
         end
      end
   end
end

local function avoid_nested(parent_type, text)
   return function(node)
      return node:parent():type() ~= parent_type and text
   end
end

local function typed_definition(symbol, type_node_type)
   local function get_type(node)
      if node:type() == type_node_type then
         return ts_utils.get_node_text(node)[1]
      end
      for _, child_node in ipairs(ts_utils.get_named_children(node)) do
         local text = get_type(child_node)
         if text then
            return text
         end
      end
   end
   return function(node)
      local text = get_type(node)
      if text then
         return symbol .. " (" .. text .. ")"
      end
      return symbol
   end
end

local function avoid_being_parent_of(children_types, root_type, text)
   return function(node)
      local node_under_cursor = ts_utils.get_node_at_cursor(0)
      while node_under_cursor:type() ~= root_type and (not vim.tbl_contains(children_types, node_under_cursor:type()) or node_under_cursor:parent() ~= node) do
         node_under_cursor = node_under_cursor:parent()
      end
      if node_under_cursor:type() == root_type then
         return text
      end
   end
end

local context_maps = {
   java = {
      class_declaration = named_definition("ﴯ", "identifier"),
      interface_declaration = named_definition("", "identifier"),
      enum_declaraion = named_definition("", "identifier"),
      -- TODO: record support when TS supports it
      -- TODO: parse modifiers
      constructor_declaration = named_definition("", "identifier"),
      -- TODO: change icon and display type
      object_creation_expression = java_anonymous_class("ﴯ"),

      method_declaration = named_definition("", "identifier"),
      lambda_expression = "λ lambda",

      while_statement = " while",
      do_statement = " do-while",
      enhanced_for_statement = " enhanced for",
      for_statement = " for",
      if_statement = avoid_nested("if_statement", " if"),
      switch_expression = " switch",
      try_statement = avoid_being_parent_of({ "catch_clause", "finally_clause" }, "program", " try"),
      catch_clause = typed_definition(" catch", "catch_type"),
      finally_clause = " finally",
   },
   lua = {
      function_declaration = named_definition("", "identifier"),
      function_definition = "λ lambda",

      while_statement = " while",
      repeat_statement = " repeat",
      for_in_statement = " for-in",
      for_statement = " for",
      if_statement = " if",
   },
}

local function get_context()
   if context_maps[vim.bo.filetype] then
      local symbol_fns = context_maps[vim.bo.filetype]

      local curr_node = ts_utils.get_node_at_cursor()
      local lines = {}

      while curr_node do
         local symbol = symbol_fns[curr_node:type()]
         if type(symbol) == "function" then
            local result = symbol(curr_node)
            if result then
               table.insert(lines, 1, result)
            end
         elseif type(symbol) == "string" then
            table.insert(lines, 1, symbol)
         end
         curr_node = curr_node:parent()
      end

      return table.concat(lines, "  ")
   end

   return ""
end

lualine.setup {
   sections = {
      lualine_a = { get_mode },
      lualine_b = { { "filename", symbols = { modified = " ", readonly = " " } } },
      lualine_c = { get_context },
      lualine_x = { "diagnostics" },
      lualine_y = { "branch", "diff", "encoding", "fileformat", "filetype" },
      lualine_z = { "location", "progress" },
   },
   --sections = {
   --   lualine_a = { get_mode },
   --   lualine_b = { "branch", "diff", "encoding", "fileformat", "filetype" },
   --   lualine_c = { { "filename", symbols = { modified = " +", readonly = " " } } },
   --   lualine_x = { "diagnostics" },
   --   lualine_y = { "location", "progress" },
   --   lualine_z = { text_info },
   --},
   options = {
      theme = dofile(vim.fn.stdpath("data") .. "/site/pack/packer/opt/lualine.nvim/lua/lualine/themes/onedark.lua")
   },
   -- TODO: see how extensions work and add one for help
   extensions = {
      "nvim-tree",
   },
}
