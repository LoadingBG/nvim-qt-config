local function diagnostics_indicator(_, _, diagnostics_dict, _)
   local s = " "
   for err_type, count in pairs(diagnostics_dict) do
      if err_type == "error" then
         s = s .. count .. " "
      elseif err_type == "warning" then
         s = s .. count .. " "
      else
         s = s .. count .. " "
      end
   end
   return s
end

require("bufferline").setup {
   options = {
      numbers = function(info) return tostring(info.id) end,
      modified_icon = "",
      diagnostics = "nvim_lsp",
      diagnostics_indicator = diagnostics_indicator,
      offsets = {
         {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "center",
         },
         {
            filetype = "packer",
            text = "Packer",
            text_align = "center",
         },
         {
            filetype = "help",
            text = function()
               return "Help: " .. vim.fn.expand("%:t")
            end,
            text_align = "center",
         },
         {
            filetype = "tsplayground",
            text = "Treesitter Playground",
            text_align = "center",
         },
      },
      show_buffer_icons = true,
      show_buffer_close_icons = false,
      show_close_icon = false,
      separator_style = "slant",
   },
   highlights = {
      --fill = {
      --   guibg = { highlight = "lualine_c_normal", attribute = "bg" },
      --},
      --background = {
      --   guifg = { highlight = "lualine_b_normal", attribute = "fg" },
      --   guibg = { highlight = "lualine_b_normal", attribute = "bg" },
      --},
      --buffer_visible = {
      --   guifg = { highlight = "LualineModeColorc", attribute = "fg" },
      --   guibg = { highlight = "LualineModeColorc", attribute = "bg" },
      --   gui = "bold",
      --},
      --buffer_selected = {
      --   guifg = { highlight = "LualineModeColorn", attribute = "fg" },
      --   guibg = { highlight = "LualineModeColorn", attribute = "bg" },
      --   gui = "bold",
      --},
      --separator_selected = {
      --   guifg = { highlight = "LualineModeColorn", attribute = "bg" },
      --   guibg = { highlight = "lualine_b_normal", attribute = "bg" },
      --}
   },
}
