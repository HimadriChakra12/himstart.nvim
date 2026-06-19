vim.pack.add {
  'https://github.com/ellisonleao/gruvbox.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/lewis6991/gitsigns.nvim',
}

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
local o = vim.opt
o.number = true
o.relativenumber = true
o.ignorecase = true
o.smartcase = true
o.smartindent = true
o.undofile = true
o.splitright = true
o.scrolloff = 10
o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.wrap = true
o.linebreak = true
o.path = '**'

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('himadri-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

require 'himadri.dashboard'
require 'himadri.heads'
require 'himadri.style'
require 'himadri.theme'
require('himadri.zoxide').setup()
require 'himadri.args'
require 'himadri.pin'
require 'himadri.keybinds'

require 'theradlectures.terminalflaot'

require 'plugins.builtin'
require 'plugins.git'
require 'plugins.fuzzy'
require 'plugins.files'
