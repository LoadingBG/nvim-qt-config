-- Disable some built-in plugins
local disabled_built_ins = {
   "netrw",
   "netrwPlugin",
   "netrwSettings",
   "netrwFileHandlers",
}
for _, plugin in pairs(disabled_built_ins) do
   vim.g["loaded_" .. plugin] = true
end

-- Bootstrap Packer
local packer_bootstrap
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
   packer_bootstrap = vim.fn.system {
      "git",
      "clone",
      "--depth",
      "1",
      "https://github.com/wbthomason/packer.nvim",
      install_path,
   }
end

local function get_spec(name, packer_opts)
   -- Create spec with the passed options
   local spec = { name }
   if packer_opts then
      spec = vim.tbl_extend("keep", spec, packer_opts)
   end

   local settings_filename = name:gsub("^.+/", ""):gsub("%.", "_dot_")

   -- Find config file and add it to spec
   for _, searcher in ipairs(package.searchers or package.loaders) do
      local config_loader = searcher("plugins.config." .. settings_filename)
      if type(config_loader) == "function" then
         spec = vim.tbl_extend("force", spec, { config = config_loader })
         break
      end
   end

   -- Execute keymaps if available
   pcall(require, "plugins.keymaps." .. settings_filename)

   return spec
end

return require("packer").startup {
   config = {
      profile = { enable = true },
   },
   function(use)
      use {
         ----- Utilities -----

         --- Packer ---
         get_spec("wbthomason/packer.nvim"), -- Packer itself
         --- For other plugins ---
         get_spec("kyazdani42/nvim-web-devicons", { as = "icons" }), -- Additional icons
         get_spec("nvim-lua/plenary.nvim", { as = "plenary" }), -- Additional functionality
         get_spec("tami5/sqlite.lua", { as = "sqlite" }), -- SQLite support
         get_spec("nvim-lua/popup.nvim", { as = "popup" }), -- Popup API implementation
         --- Miscellaneous ---
         get_spec("antoinemadec/FixCursorHold.nvim"), -- Fix for CursorHold and CursorHoldI events

         ----- Cosmetics -----

         --- Themes ---
         get_spec("navarasu/onedark.nvim", { as = "theme" }), -- Atom One Dark theme
         --- Highlighting ---
         get_spec("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" }), -- Highlighter
         get_spec("norcalli/nvim-colorizer.lua", { run = ":ColorizerToggle" }), -- Color code colorizer
         --- Statusline and tabline configurators ---
         get_spec("nvim-lualine/lualine.nvim", { requires = "icons", after = "theme" }), -- Statusline
         get_spec("akinsho/bufferline.nvim", { requires = "icons" }), -- Bufferline
         --- Miscellaneous ---
         get_spec("lukas-reineke/indent-blankline.nvim"), -- Indentation guides
         get_spec("rcarriga/nvim-notify"), -- Fancy notifier

         ----- Functionality -----

         get_spec("dstein64/vim-startuptime", { cmd = "StartupTime" }), -- Startup time profiler
         --- LSP ---
         get_spec("neovim/nvim-lspconfig"), -- LSP configurator
         get_spec("williamboman/nvim-lsp-installer"), -- LSP manager
         get_spec("folke/trouble.nvim", { requires = "icons" }), -- Diagnostics location list
         --get_spec("glepnir/lspsaga.nvim"), -- Code actions
         --- Autocompletion ---
         get_spec("hrsh7th/cmp-nvim-lsp"), -- Neovim LSP completion source
         get_spec("hrsh7th/cmp-buffer"), -- Buffer completion source
         get_spec("hrsh7th/cmp-path"), -- Path completion source
         get_spec("hrsh7th/cmp-cmdline"), -- Commandline completion source
         get_spec("hrsh7th/cmp-nvim-lua"), -- Neovim Lua API completion source
         get_spec("ray-x/cmp-treesitter"), -- Treesitter completion source
         get_spec("hrsh7th/cmp-nvim-lsp-signature-help"), -- Function signatures completion source
         get_spec("hrsh7th/nvim-cmp"), -- Autocompletion engine
         get_spec("L3MON4D3/LuaSnip"), -- Snippets engine
         get_spec("saadparwaiz1/cmp_luasnip"), -- Snippets integration
         --- Fuzzy finding ---
         get_spec("nvim-telescope/telescope.nvim", { as = "telescope", requires = "plenary" }), -- Fuzzy finder
         get_spec("nvim-telescope/telescope-fzy-native.nvim"), -- Native FZY sorter
         get_spec("nvim-telescope/telescope-github.nvim", { requires = "plenary" }), -- Github integration
         get_spec("nvim-telescope/telescope-file-browser.nvim", { requires = "plenary" }), -- File browser
         get_spec("sudormrfbin/cheatsheet.nvim", { requires = { "telescope", "popup", "plenary" } }), -- Telescope cheatsheet
         --get_spec("nvim-telescope/telescope-arecibo.nvim", { rocks = { "openssl", "lua-http-parser" } }), -- Web searcher
         --- Zen mode ---
         -- TODO: make lazy
         get_spec("folke/zen-mode.nvim"), -- Zen mode
         get_spec("folke/twilight.nvim"), -- Make current context stand out
         --- Miscellaneous ---
         get_spec("tpope/vim-fugitive"), -- Git integration
         get_spec("lewis6991/gitsigns.nvim", { requires = "plenary" }), -- Git diff signs
         get_spec("kyazdani42/nvim-tree.lua", { requires = "icons" }), -- File explorer
         get_spec("andweeb/presence.nvim"), -- Discord RPC
         get_spec("nvim-treesitter/playground", { cmd = "TSPlaygroundToggle" }), -- Treesitter parser results viewer
         get_spec("alec-gibson/nvim-tetris", { cmd = "Tetris" }), -- Tetris
      }

      if packer_bootstrap then
         require("packer").sync()
      end
   end
}
