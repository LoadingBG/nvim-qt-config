local utils = require("utils")

utils.nnoremap("<Leader>fg", "<Cmd>Telescope live_grep<CR>")
utils.nnoremap("<Leader>fb", "<Cmd>Telescope buffers<CR>")
utils.nnoremap("<Leader>fh", "<Cmd>Telescope help_tags<CR>")

-- aceribo
-- utils.nnoremap("<Leader>sw", "<Cmd>lua require('telescope').extensions.arecibo.websearch()<CR>")
-- gh
utils.nnoremap("<Leader>ghi", "<Cmd>Telescope gh issues<CR>")
utils.nnoremap("<Leader>ghp", "<Cmd>Telescope gh pull_request<CR>")
utils.nnoremap("<Leader>ghg", "<Cmd>Telescope gh gist<CR>")
utils.nnoremap("<Leader>ghr", "<Cmd>Telescope gh run<CR>")
-- file_browser
utils.nnoremap("<Leader>ff", "<Cmd>lua require('telescope').extensions.file_browser.file_browser()<CR>")
-- notify
utils.nnoremap("<Leader>fn", "<Cmd>lua require('telescope').extensions.notify.notify()<CR>")
