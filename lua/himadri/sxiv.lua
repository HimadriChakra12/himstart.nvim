-- File: ~/.config/nvim/lua/himadri/image_handler.lua
-- Usage: require("himadri.image_handler").setup()

local M = {}

local image_extensions = { '.png', '.jpg', '.jpeg', '.gif', '.webp' }

-- check if a string is an image
local function is_image(path)
  if not path then
    return false
  end
  local lower = path:lower()
  for _, ext in ipairs(image_extensions) do
    if lower:sub(-#ext) == ext then
      return true
    end
  end
  return false
end

-- open file in sxiv
local function open_sxiv(path)
  vim.fn.jobstart({ 'sxiv', '-f', path }, { detach = true })
end

-- ---------- 1. BufReadPre hook for actual image files ----------
function M.setup_bufread()
  vim.api.nvim_create_autocmd('BufReadPre', {
    callback = function(args)
      local file = args.file
      if is_image(file) then
        open_sxiv(file)
        -- prevent buffer from appearing
        vim.schedule(function()
          local bufnr = vim.fn.bufnr '%'
          if vim.api.nvim_buf_is_valid(bufnr) then
            vim.api.nvim_buf_delete(bufnr, { force = true })
          end
        end)
      end
    end,
  })
end

-- ---------- 2. Keymap for Markdown/text image paths ----------
local function get_image_under_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1

  -- Try Markdown image syntax ![alt](path)
  for path in line:gmatch '%((.-)%)' do
    local s, e = line:find('%(' .. path:gsub('([%%%^%$%(%)%.%[%]%*%+%-%?])', '%%%1') .. '%)')
    if s <= col and col <= e then
      return path
    end
  end

  -- fallback: WORD under cursor
  local word = vim.fn.expand '<cWORD>'
  if is_image(word) then
    return word
  end
end

function M.setup_keymaps()
  vim.keymap.set('n', '<CR>', function()
    local path = get_image_under_cursor()
    if path and is_image(path) then
      open_sxiv(path)
    else
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, false, true), 'n', false)
    end
  end, { noremap = true, silent = true })

  vim.keymap.set('n', 'gv', function()
    local path = get_image_under_cursor()
    if path and is_image(path) then
      open_sxiv(path)
    end
  end, { noremap = true, silent = true })
end

-- ---------- 3. Setup function ----------
function M.setup()
  M.setup_bufread()
  M.setup_keymaps()
end

return M
