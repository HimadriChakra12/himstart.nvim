vim.pack.add {
  'https://github.com/ellisonleao/gruvbox.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/echasnovski/mini.nvim',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/saghen/blink.cmp',
  'https://github.com/L3MON4D3/LuaSnip',
  'https://github.com/folke/lazydev.nvim',
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/stevearc/conform.nvim',
}

require 'options'
require 'keymaps'
require 'autocmds'
require 'himadri.himadri'
require 'theradlectures.terminalflaot'
require 'plugins.builtin'
require 'plugins.ui'
require 'plugins.git'
require 'plugins.fuzzy'
require 'plugins.lsp'
require 'plugins.completion'
require 'plugins.formatting'
require 'plugins.treesitter'
