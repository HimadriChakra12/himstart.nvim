local M = {}
local history = {}
local history_index = 0

-- open a vsplit for browsing
local function open_split()
  vim.cmd 'vsplit'
  return vim.api.nvim_get_current_win()
end

-- render plain text from w3m
local function render_buffer(url)
  local win = open_split()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(win, buf)

  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = true
  vim.bo[buf].filetype = 'markdown'

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { 'Loading ' .. url .. ' ...' })

  -- update history
  history_index = history_index + 1
  history[history_index] = url
  for i = history_index + 1, #history do
    history[i] = nil
  end

  vim.fn.jobstart({ 'w3m', '-dump', '-cols', '100', url }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if not data then
        return
      end
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end
        if #data == 0 then
          data = { '[No readable content]' }
        end
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, data)
      end)
    end,
  })

  local opts = { buffer = buf, silent = true }
  vim.keymap.set('n', 'q', '<cmd>bd!<CR>', opts)
  vim.keymap.set('n', 'b', function()
    if history_index > 1 then
      history_index = history_index - 1
      M.open(history[history_index])
    end
  end, opts)
  vim.keymap.set('n', 'f', function()
    if history_index < #history then
      history_index = history_index + 1
      M.open(history[history_index])
    end
  end, opts)
  vim.keymap.set('n', 'r', function()
    M.open(history[history_index])
  end, opts)
end

function M.open(url)
  if not url then
    vim.ui.input({ prompt = 'URL: ' }, function(input)
      if input then
        M.open(input)
      end
    end)
    return
  end
  render_buffer(url)
end

vim.keymap.set('n', 'gu', function()
  local word = vim.fn.expand '<cWORD>'
  if word:match '^https?://' then
    M.open(word)
  else
    vim.cmd 'normal! gu'
  end
end, { silent = true })

vim.api.nvim_create_user_command('Web', function()
  M.open()
end, {})

return M
