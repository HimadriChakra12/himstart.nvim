local M = {}

------------------------------------------------------------
-- Utility: wipe useless [No Name] buffers (repeat-safe)
------------------------------------------------------------
local function wipe_empty_buffers()
  local wiped = false

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) == '' and vim.bo[buf].buftype == '' then
      vim.api.nvim_buf_delete(buf, { force = true })
      wiped = true
    end
  end

  return wiped
end

------------------------------------------------------------
-- Git status (short)
------------------------------------------------------------
local function get_git_status()
  local inside = vim.fn.systemlist('git rev-parse --is-inside-work-tree')[1]
  if inside ~= 'true' then
    return nil
  end

  local lines = vim.fn.systemlist 'git status --short --branch'
  if vim.v.shell_error ~= 0 or not lines then
    return nil
  end

  local branch = lines[1]:match '^##%s+([^%.]+)' or 'detached'

  local stats = {
    added = 0,
    modified = 0,
    deleted = 0,
    untracked = 0,
  }

  for i = 2, #lines do
    local l = lines[i]
    if l:match '^%?%?' then
      stats.untracked = stats.untracked + 1
    elseif l:match '^A' or l:match '^M ' then
      stats.added = stats.added + 1
    elseif l:match '^ M' then
      stats.modified = stats.modified + 1
    elseif l:match '^ D' or l:match '^D ' then
      stats.deleted = stats.deleted + 1
    end
  end

  return {
    branch = branch,
    stats = stats,
  }
end

------------------------------------------------------------
-- Dashboard
------------------------------------------------------------
function M.show()
  -- Keep nuking [No Name] buffers until Neovim stops spawning them
  vim.defer_fn(function()
    while wipe_empty_buffers() do
    end
  end, 0)

  ----------------------------------------------------------
  -- Highlights
  ----------------------------------------------------------
  vim.cmd [[
    highlight! DashboardHeader    guifg=#b8bb26
    highlight! DashboardGitTitle  guifg=#83a598
    highlight! DashboardGitStats  guifg=#fabd2f
  ]]

  ----------------------------------------------------------
  -- Header
  ----------------------------------------------------------
  local header = {
    '',
    '',
    '   ██    ███   ████',
    '   ██   ████     ████    █████     ██   ████',
    '   ██  ██ ██      ███     ██       ██   ██',
    '   ████   ██   ████  ██   ██  ████ ██   ██',
    '   ██     ██  ██     ███  █████    ██   ██',
    '          ███                      █████',
    '           ████  ███████████████   ██',
    '                                   ██',
    '',
    '                  Neovim ' .. vim.version().major .. '.' .. vim.version().minor,
    '',
  }

  ----------------------------------------------------------
  -- Pins
  ----------------------------------------------------------
  local pinner = require 'himadri.pin'
  local pins = pinner.get_pins()

  local pin_lines = { '  Pinned' }
  if #pins == 0 then
    table.insert(pin_lines, '  No files pinned.')
  else
    for _, pin in ipairs(pins) do
      table.insert(pin_lines, string.format('  %s. [%s]', pin.key, vim.fn.fnamemodify(pin.path, ':~')))
    end
  end

  ----------------------------------------------------------
  -- Git section
  ----------------------------------------------------------
  local git = get_git_status()
  local git_lines = {}

  if git then
    git_lines = {
      '',
      '  Git',
      string.format('   %s  +%d ~%d -%d ?%d', git.branch, git.stats.added, git.stats.modified, git.stats.deleted, git.stats.untracked),
    }
  end

  ----------------------------------------------------------
  -- Recent files
  ----------------------------------------------------------
  local recent_files = {}
  local counter = 1

  for _, file in ipairs(vim.v.oldfiles) do
    if counter > 9 then
      break
    end
    if vim.fn.filereadable(file) == 1 then
      table.insert(recent_files, {
        text = string.format('  %d. [%s]', counter, file),
        path = file,
      })
      counter = counter + 1
    end
  end

  ----------------------------------------------------------
  -- Footer
  ----------------------------------------------------------
  local footer = {
    '',
    '  [n] New File',
    '  [h] Help',
    '  [q] Quit',
    '  [o],[Enter] Open file',
    '',
  }

  ----------------------------------------------------------
  -- Create buffer
  ----------------------------------------------------------
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(buf, 'Welcome, Himadri')

  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].swapfile = false
  vim.bo[buf].buflisted = false
  vim.bo[buf].modifiable = true
  vim.bo[buf].filetype = 'dashboard'

  vim.wo.number = false
  vim.wo.relativenumber = false

  ----------------------------------------------------------
  -- Build content
  ----------------------------------------------------------
  local content = vim.list_extend({}, header)
  vim.list_extend(content, pin_lines)
  vim.list_extend(content, git_lines)

  table.insert(content, '')
  table.insert(content, '  Recent:')

  for _, item in ipairs(recent_files) do
    table.insert(content, item.text)
  end

  vim.list_extend(content, footer)

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

  ----------------------------------------------------------
  -- Highlights
  ----------------------------------------------------------
  for i = 3, 8 do
    vim.api.nvim_buf_add_highlight(buf, -1, 'DashboardHeader', i - 1, 0, -1)
  end

  if git then
    local git_start = #header + #pin_lines + 1
    vim.api.nvim_buf_add_highlight(buf, -1, 'DashboardGitTitle', git_start, 0, -1)
    vim.api.nvim_buf_add_highlight(buf, -1, 'DashboardGitStats', git_start + 1, 0, -1)
  end

  vim.bo[buf].modifiable = false

  ----------------------------------------------------------
  -- Show buffer
  ----------------------------------------------------------
  vim.api.nvim_set_current_buf(buf)
  vim.api.nvim_win_set_cursor(0, { 20, 6 })

  ----------------------------------------------------------
  -- Keymaps
  ----------------------------------------------------------
  local opts = { buffer = buf, silent = true, nowait = true }

  for i, item in ipairs(recent_files) do
    vim.keymap.set('n', tostring(i), function()
      vim.cmd('edit ' .. vim.fn.fnameescape(item.path))
    end, opts)
  end

  local function open_line()
    local line = vim.api.nvim_get_current_line()

    local key = line:match '^%s*([%a])%. '
    if key then
      for _, pin in ipairs(pins) do
        if pin.key == key then
          vim.cmd('edit ' .. vim.fn.fnameescape(pin.path))
          return
        end
      end
    end

    local path = line:match '%[(.*)%]'
    if path and vim.fn.filereadable(path) == 1 then
      vim.cmd('edit ' .. vim.fn.fnameescape(path))
    end
  end

  vim.keymap.set('n', '<CR>', open_line, opts)
  vim.keymap.set('n', 'o', open_line, opts)
  vim.keymap.set('n', 'n', ':enew<CR>', opts)
  vim.keymap.set('n', 'h', ':help<CR>', opts)
  vim.keymap.set('n', 'q', ':qa<CR>', opts)
end

------------------------------------------------------------
-- Autocommands
------------------------------------------------------------
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    vim.schedule(M.show)
  end,
  desc = 'Show dashboard on startup',
})

vim.api.nvim_create_user_command('Dashboard', function()
  M.show()
end, {})

return M
