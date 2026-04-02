return {
  { 'NMAC427/guess-indent.nvim' },

  {
    'HimadriChakra12/hsc.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'L3MON4D3/LuaSnip',
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function() require('hsc').setup() end,
  },

  {
    'HimadriChakra12/calendar.nvim',
    keys = {
      { '<leader>ca', '<cmd>Calendar<cr>', desc = 'Open Calendar' },
      { '<leader>ct', '<cmd>CalAdd<cr>',  desc = 'Add Task Today' },
    },
    config = function() require('calendar').setup() end,
  },

  {
    'HimadriChakra12/excel.nvim',
    opts = {
      open_csv = false, python_cmd = 'python3', max_col_width = 20,
      auto_recalc = false, show_gridlines = true, show_formulas = false,
    },
  },

  {
    'ck-zhang/mistake.nvim',
    config = function()
      local plugin = require 'mistake'
      vim.defer_fn(function() plugin.setup() end, 500)
      vim.keymap.set('n', '<leader>ma', plugin.add_entry,             { desc = '[M]istake [A]dd entry' })
      vim.keymap.set('n', '<leader>me', plugin.edit_entries,          { desc = '[M]istake [E]dit entries' })
      vim.keymap.set('n', '<leader>mc', plugin.add_entry_under_cursor,{ desc = '[M]istake add [C]urrent word' })
    end,
  },

  {
    'https://gitlab.com/itaranto/id3.nvim',
    version = '*',
    config = function() require('id3').setup() end,
  },
}
