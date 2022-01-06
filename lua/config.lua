----- Editor Settings -----
vim.o.number = true -- Enable numbering
vim.o.relativenumber = true -- Enable relative numbering
vim.o.clipboard = "unnamedplus" -- Set clipboard to paste to "+ register
vim.o.guifont = "FiraCode NF:h11" -- Use FiraCode NF font
vim.fn.rpcnotify(0, "Gui", "Option", "RenderLigatures", 1) -- Render ligatures
vim.fn.rpcnotify(0, "Gui", "Option", "Popupmenu", 0) -- Disable GUI pop-up menu
vim.fn.rpcnotify(0, "Gui", "Option", "Tabline", 0) -- Disable GUI tabline
vim.cmd("cd ~") -- Change the working directory to home
vim.o.splitbelow = true -- Split horizontal buffers below
vim.o.splitright = true -- Split vertical buffers to the right
vim.o.cursorline = true -- Enable cursor line
vim.o.cursorcolumn = true -- Enable cursor column
vim.o.updatetime = 100 -- Set the update time to 100 ms

----- Shell Settings (Copied from ':h shell-powershell`) -----
vim.o.shell = "powershell"
vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
vim.o.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
vim.o.shellquote = ""
vim.o.shellxquote = ""

----- Default Indentation Settings -----
vim.o.tabstop = 4 -- Make tab equal 4 spaces
vim.o.shiftwidth = 4 -- Make tab key use 4 spaces
vim.o.expandtab = true -- Expand tabs into spaces
vim.o.smartindent = true -- Indent next line based on previous one

----- Commands -----
vim.cmd("com Hitest so $VIMRUNTIME/syntax/hitest.vim")

----- Rust settings (while ftplugin/ doesn't work) -----
vim.cmd([[
   aug RustSettings
      au!
      au FileType rust exe 'setlocal colorcolumn=' . join(range(81, 355), ',')
   aug END
]])
