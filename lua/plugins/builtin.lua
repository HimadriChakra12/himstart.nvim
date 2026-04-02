-- lua/plugins/builtin.lua

-- Editorconfig: built into Neovim 0.9+, enabled by default
vim.g.editorconfig = true

-- Spellfile: no setup needed, works automatically when spell is on
-- enable spell per filetype in ftplugin or autocmd if you want it

-- Undotree: runtime plugin, load via runtime
vim.cmd.runtime 'plugin/undotree.vim'
vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<CR>', { desc = 'Toggle [U]ndotree' })

-- Tohtml: runtime plugin, lazy-load only when commanded
vim.api.nvim_create_user_command('ToHTML', function()
  vim.cmd.runtime 'plugin/tohtml.vim'
  vim.cmd.TOhtml()
end, {})
