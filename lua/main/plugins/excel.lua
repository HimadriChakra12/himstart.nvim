return {
  'brianhuster/live-preview.nvim',
  dependencies = {
    -- You can choose one of the following pickers
    'ibhagwan/fzf-lua',
  },
  opts = {
    port = 5500,
    browser = 'default',
    dynamic_root = false,
    sync_scroll = true,
    picker = '',
    address = '127.0.0.1',
  },
}
