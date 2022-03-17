local utils = require("utils")

-- See https://github.com/williamboman/nvim-lsp-installer/wiki/Advanced-Configuration

local installer = require("nvim-lsp-installer")

local required = {
   "jdtls",
   "sumneko_lua",
}

for _, name in pairs(required) do
   local server_is_found, server = installer.get_server(name)
   if not server_is_found then
      error("Server "..name.." is not found")
   elseif not server:is_installed() then
      print("Installing "..name)
      server:install()
   end
end

local function on_attach(client, bufnr)
   vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

   utils.buf_silent_nnoremap(bufnr, "gD",         "<Cmd>lua vim.lsp.buf.declaration()<CR>")
   utils.buf_silent_nnoremap(bufnr, "gd",         "<Cmd>lua vim.lsp.buf.definition()<CR>")
   utils.buf_silent_nnoremap(bufnr, "K",          "<Cmd>lua vim.lsp.buf.hover()<CR>")
   utils.buf_silent_nnoremap(bufnr, "gi",         "<Cmd>lua vim.lsp.buf.implementation()<CR>")
   utils.buf_silent_nnoremap(bufnr, "<C-k>",      "<Cmd>lua vim.lsp.buf.signature_help()<CR>")
   utils.buf_silent_nnoremap(bufnr, "<Leader>wa", "<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
   utils.buf_silent_nnoremap(bufnr, "<Leader>wr", "<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
   utils.buf_silent_nnoremap(bufnr, "<Leader>wl", "<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>")
   utils.buf_silent_nnoremap(bufnr, "<Leader>D",  "<Cmd>lua vim.lsp.buf.type_definition()")
   utils.buf_silent_nnoremap(bufnr, "<leader>rn", "<CMD>lua vim.lsp.buf.rename()<CR>")
   utils.buf_silent_nnoremap(bufnr, "gr",         "<CMD>lua vim.lsp.buf.references()<CR>")
   utils.buf_silent_nnoremap(bufnr, "<leader>e",  "<CMD>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
   utils.buf_silent_nnoremap(bufnr, "[d",         "<CMD>lua vim.lsp.diagnostic.goto_prev()<CR>")
   utils.buf_silent_nnoremap(bufnr, "]d",         "<CMD>lua vim.lsp.diagnostic.goto_next()<CR>")
   utils.buf_silent_nnoremap(bufnr, "<leader>q",  "<CMD>lua vim.lsp.diagnostic.set_loclist()<CR>")

   -- Set some keybinds conditional on server capabilities (Figure out a good key combination
   --if client.resolved_capabilities.document_formatting then
   --   vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-d>", "<CMD>lua vim.lsp.buf.formatting()<CR>", opts)
   --elseif client.resolved_capabilities.document_range_formatting then
   --   vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-d>", "<CMD>lua vim.lsp.buf.range_formatting()<CR>", opts)
   --end

   -- Set autocommands conditional on server_capabilities
   if client.resolved_capabilities.document_highlight then
      vim.api.nvim_exec([[
      aug LspHighlight
         au! * <buffer>
         au CursorHold <buffer> lua vim.lsp.buf.document_highlight()
         au CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      aug END
      ]], false)
   end
end

local server_settings = {
   ["sumneko_lua"] = {
      Lua = {
         runtime = {
            version = "LuaJIT",
            path = vim.split(package.path, ";"),
         },
         diagnostics = {
            globals = {
               "vim",
            },
         },
         workspace = {
            library = {
               [vim.fn.expand("$VIMRUNTIME/lua")] = true,
               [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
            },
         },
      },
   },
}

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

installer.on_server_ready(function(server)
   server:setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = server_settings[server.name]
   }
   --server:setup(require("coq").lsp_ensure_capabilities {
   --   on_attach = on_attach,
   --   settings = server_settings[server.name],
   --})
end)
