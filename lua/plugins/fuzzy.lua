local fzf = require 'fzf-lua'
fzf.setup {
  winopts = { preview = { default = 'bat' } },
  buffers = { sort_lastused = true, ignore_current_buffer = true },
  lsp = { jump_to_single_result = true, async_or_timeout = 3000 },
}
vim.keymap.set('n', '<leader>sh', fzf.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', fzf.keymaps,   { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>o',        fzf.files,    { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>oo',       fzf.oldfiles, { desc = '[S]earch Recent Files' })
vim.keymap.set('n', '<leader><leader>', fzf.buffers,  { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>fw', fzf.grep_cword,          { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>ff', fzf.live_grep,           { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', fzf.diagnostics_document, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>th', function()
  fzf.blines {
    winopts = { height = 0.4, width = 0.6, preview = { hidden = 'hidden' } },
  }
end, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>/', function()
  fzf.live_grep { grep_open_files = true, prompt = 'Live Grep in Open Files> ' }
end, { desc = '[S]earch [/] in Open Files' })
vim.keymap.set('n', '<leader>c', function()
  fzf.files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim files' })
