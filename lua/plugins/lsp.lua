local capabilities = require('blink.cmp').get_lsp_capabilities()

vim.lsp.config('lua_ls', {
  capabilities = capabilities,
  settings = {
    Lua = { completion = { callSnippet = 'Replace' } },
  },
})

vim.lsp.config('bashls', {
  capabilities = capabilities,
})

vim.lsp.enable('lua_ls')
vim.lsp.enable('bashls')
