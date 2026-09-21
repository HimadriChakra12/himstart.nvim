--require('id3').setup()
--require('hsc').setup()
require('calendar').setup {
  keys = {
    { '<leader>ca', '<cmd>Calendar<cr>', desc = 'Open Calendar' },
    { '<leader>ct', '<cmd>CalAdd<cr>', desc = 'Add Task Today' },
  },
}
