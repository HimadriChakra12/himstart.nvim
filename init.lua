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

-- Transparent background
vim.api.nvim_set_hl(0, "Normal", { fg = "#ebdbb2", bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#7c6f64", bg = "none" })
vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = "#3c3836", bg = "none" })

-- Gruvbox-like syntax colors
vim.api.nvim_set_hl(0, "Comment", { fg = "#928374", italic = true })
vim.api.nvim_set_hl(0, "String", { fg = "#b8bb26" })
vim.api.nvim_set_hl(0, "Function", { fg = "#fabd2f" })
vim.api.nvim_set_hl(0, "Keyword", { fg = "#fb4934" })
vim.api.nvim_set_hl(0, "Type", { fg = "#8ec07c" })
vim.api.nvim_set_hl(0, "Constant", { fg = "#d3869b" })
vim.api.nvim_set_hl(0, "Identifier", { fg = "#83a598" })
vim.api.nvim_set_hl(0, "PreProc", { fg = "#fe8019" })


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
