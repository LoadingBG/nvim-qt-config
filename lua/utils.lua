local M = {}


----- Debug functions -----

function M.show_hl_groups_in_line(line_num)
   local line = vim.fn.getline(line_num)
   local groups = {}
   for col = 1, #line do
      local hl_group_name = vim.fn.synIDattr(vim.fn.synID(line_num, col, 1), "name")
      if #groups == 0 then
         table.insert(groups, { name = hl_group_name, start = col, finish = col })
      else
         local last_group = groups[#groups]
         if hl_group_name == last_group.name then
            groups[#groups].finish = col
         else
            table.insert(groups, { name = hl_group_name, start = col, finish = col })
         end
      end
   end

   local output = line .. "\n"

   for _, group in ipairs(groups) do
      local start = group.start
      local finish = group.finish
      if start == finish then
         output = output .. "V"
      else
         output = output .. "\\"
         for _ = start, finish - 2 do
            output = output .. "_"
         end
         output = output .. "/"
      end
   end
   output = output .. "\n"

   for idx = #groups, 1, -1 do
      for place, group in ipairs(groups) do
         if place < idx then
            output = output .. "|" .. (" "):rep(group.finish - group.start)
         elseif place == idx then
            output = output .. (group.name == "" and "[NONE]" or group.name)
            break
         end
      end
      output = output .. "\n"
   end

   print(output)
end

function M.show_hl_groups_in_current_line()
   M.show_hl_groups_in_line(vim.fn.line("."))
end



----- Neovim Functions -----



function M.nnoremap(keys, func)
   vim.api.nvim_set_keymap("n", keys, func, { noremap = true })
end

function M.silent_nnoremap(keys, func)
   vim.api.nvim_set_keymap("n", keys, func, { noremap = true, silent = true })
end

function M.buf_silent_nnoremap(bufnr, keys, func)
   vim.api.nvim_buf_set_keymap(bufnr, "n", keys, func, { noremap = true, silent = true })
end

return M
