-- ---------- Mini CSV helper v3 ----------

if vim.g.minicsv_loaded then
  return
end
vim.g.minicsv_loaded = true

local group = vim.api.nvim_create_augroup('MiniCSV', { clear = true })

-- =======================
-- Core Functions
-- =======================

-- Align columns visually (temporary)
local function align_csv()
  if vim.bo.filetype ~= 'csv' then
    return
  end
  local view = vim.fn.winsaveview()
  vim.cmd [[silent %!column -t -s,]]
  vim.fn.winrestview(view)
end

-- Restore raw CSV
local function restore_csv()
  if vim.bo.filetype ~= 'csv' then
    return
  end
  if vim.b.minicsv_raw then
    local view = vim.fn.winsaveview()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.b.minicsv_raw)
    vim.fn.winrestview(view)
  end
end

-- Hide commas
local function hide_commas()
  if vim.bo.filetype ~= 'csv' then
    return
  end
  vim.wo.conceallevel = 2
  vim.cmd [[syntax match csvComma /,/ conceal]]
end

-- Show commas
local function show_commas()
  if vim.bo.filetype ~= 'csv' then
    return
  end
  vim.wo.conceallevel = 0
end

-- =======================
-- Autocommands
-- =======================

-- Insert mode: restore CSV and show commas
vim.api.nvim_create_autocmd('InsertEnter', {
  pattern = '*.csv',
  group = group,
  callback = function()
    show_commas()
    restore_csv()
  end,
})

-- Filetype setup: initial CSV tweaks and keymaps
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'csv',
  group = group,
  callback = function()
    local opts = { buffer = true, silent = true }

    -- Quick comma insert in insert mode
    vim.keymap.set('i', ',,', ', ', opts)

    -- Shift+V triggers “column view” temporarily
    vim.keymap.set('n', 'V', function()
      -- Store raw CSV
      vim.b.minicsv_raw = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      -- Go to visual line mode
      vim.cmd 'normal! V'
      -- Align columns for visual view
      align_csv()
      hide_commas()
    end, opts)
  end,
})

-- Restore CSV automatically when leaving visual mode
vim.api.nvim_create_autocmd('ModeChanged', {
  pattern = '*',
  group = group,
  callback = function()
    -- Visual -> Normal transition
    if vim.fn.mode() == 'n' and vim.b.minicsv_raw then
      restore_csv()
      show_commas()
      vim.b.minicsv_raw = nil
    end
  end,
})
