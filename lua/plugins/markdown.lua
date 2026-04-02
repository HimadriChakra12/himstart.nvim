return {
  {
    'lervag/vimtex',
    ft = { 'tex', 'markdown' },
  },
  {
    'epwalsh/obsidian.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ft = 'markdown',
    opts = {
      workspaces = { { name = 'notes', path = '~/Obsidian' } },
    },
  },
  {
    'tadmccorkle/markdown.nvim',
    ft = 'markdown',
    opts = {
      mappings = {
        inline_surround_toggle      = 'gs',
        inline_surround_toggle_line = 'gss',
        inline_surround_delete      = 'ds',
        inline_surround_change      = 'cs',
        link_add                    = 'gl',
        link_follow                 = 'gx',
        go_curr_heading             = ']c',
        go_parent_heading           = ']p',
        go_next_heading             = ']]',
        go_prev_heading             = '[[',
      },
      inline_surround = {
        emphasis      = { key = 'i', txt = '*'  },
        strong        = { key = 'b', txt = '**' },
        strikethrough = { key = 's', txt = '~~' },
        code          = { key = 'c', txt = '`'  },
      },
      link = { paste = { enable = true } },
      toc  = { omit_heading = 'toc omit heading', omit_section = 'toc omit section', markers = { '-' } },
    },
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd   = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && npm install',
    ft    = { 'markdown' },
  },
  {
    'brianhuster/live-preview.nvim',
    dependencies = { 'ibhagwan/fzf-lua' },
    opts = {
      port = 5500, browser = 'default', dynamic_root = false,
      sync_scroll = true, picker = '', address = '127.0.0.1',
    },
  },
}
