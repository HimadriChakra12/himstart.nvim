vim.pack.add {
  'https://github.com/ellisonleao/gruvbox.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/stevearc/oil.nvim',
-- 'https://github.com/saghen/blink.cmp',
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/lewis6991/gitsigns.nvim',
-- 'https://github.com/HimadriChakra12/hsc.nvim',
  'https://github.com/HimadriChakra12/calendar.nvim',
  'https://github.com/ck-zhang/mistake.nvim',
--  'https://gitlab.com/itaranto/id3.nvim',
  'https://github.com/mplusp/pack-manager.nvim',
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
require 'plugins.files'
-- require 'plugins.lsp'
require 'plugins.extras'
