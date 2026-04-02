-- ── lazydev ──────────────────────────────────────────────────────────────
require('lazydev').setup {
  library = { { path = '${3rd}/luv/library', words = { 'vim%.uv' } } },
}

-- ── LSP attach ───────────────────────────────────────────────────────────
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('himadri-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end
    local fzf = require 'fzf-lua'
    map('grn', vim.lsp.buf.rename,        '[R]e[n]ame')
    map('gc',  vim.lsp.buf.code_action,   '[G]oto Code [A]ction', { 'n', 'x' })
    map('grr', fzf.lsp_references,        '[G]oto [R]eferences')
    map('gri', fzf.lsp_implementations,   '[G]oto [I]mplementation')
    map('gd',  fzf.lsp_definitions,       '[G]oto [D]efinition')
    map('grD', vim.lsp.buf.declaration,   '[G]oto [D]eclaration')
    map('gO',  fzf.lsp_document_symbols,  'Open Document Symbols')
    map('gW',  fzf.lsp_workspace_symbols, 'Open Workspace Symbols')
    map('grt', fzf.lsp_typedefs,          '[G]oto [T]ype Definition')

    local function client_supports(client, method, bufnr)
      if vim.fn.has 'nvim-0.11' == 1 then
        return client:supports_method(method, bufnr)
      end
      return client.supports_method(method, { bufnr = bufnr })
    end

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client_supports(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local aug = vim.api.nvim_create_augroup('himadri-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf, group = aug,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf, group = aug,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('himadri-lsp-detach', { clear = true }),
        callback = function(e2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'himadri-lsp-highlight', buffer = e2.buf }
        end,
      })
    end

    if client and client_supports(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      map('<leader>ti', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, '[T]oggle [I]nlay Hints')
    end
  end,
})

-- ── Diagnostics ──────────────────────────────────────────────────────────
vim.diagnostic.config {
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN]  = '󰀪 ',
      [vim.diagnostic.severity.INFO]  = '󰋽 ',
      [vim.diagnostic.severity.HINT]  = '󰌶 ',
    },
  } or {},
  virtual_text = {
    source = 'if_many', spacing = 2,
    format = function(d) return d.message end,
  },
}

-- ── Servers ───────────────────────────────────────────────────────────────
local capabilities = require('blink.cmp').get_lsp_capabilities()
local servers = {
  lua_ls = {
    settings = { Lua = { completion = { callSnippet = 'Replace' } } },
  },
  bashls = {
    cmd = { 'bash-language-server', 'start' },
    filetypes = { 'sh', 'bash', 'zsh' },
  },
}

require('mason').setup()
require('mason-tool-installer').setup {
  ensure_installed = vim.list_extend(vim.tbl_keys(servers), { 'stylua', 'shfmt' }),
}
require('mason-lspconfig').setup {
  ensure_installed = {},
  automatic_installation = false,
  handlers = {
    function(server_name)
      local server = servers[server_name] or {}
      server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
      require('lspconfig')[server_name].setup(server)
    end,
  },
}
