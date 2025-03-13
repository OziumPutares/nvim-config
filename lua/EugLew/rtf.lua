-- Function to convert selected text or current buffer to HTML and copy to clipboard
local function ToHtmlClipboard(opts)
  -- Save current buffer info
  local current_buf = vim.api.nvim_get_current_buf()
  local current_win = vim.api.nvim_get_current_win()
  local cursor_pos = vim.api.nvim_win_get_cursor(current_win)

  -- Check if a range is provided
  local start_line, end_line
  if opts.range == 2 then       -- A range was provided
    start_line = opts.line1 - 1 -- Convert to 0-indexed
    end_line = opts.line2
  else                          -- No range, use the entire buffer
    start_line = 0
    end_line = vim.api.nvim_buf_line_count(current_buf)
  end

  -- Extract lines from the buffer
  local lines = vim.api.nvim_buf_get_lines(current_buf, start_line, end_line, false)

  -- Create a temporary buffer for the selected text
  local temp_buf = vim.api.nvim_create_buf(false, true)

  -- Copy filetype from current buffer to ensure proper syntax highlighting
  local filetype = vim.bo[current_buf].filetype
  vim.api.nvim_buf_set_option(temp_buf, 'filetype', filetype)

  -- Set the lines in the temporary buffer
  vim.api.nvim_buf_set_lines(temp_buf, 0, -1, false, lines)

  -- Set the temporary buffer as current
  vim.api.nvim_set_current_buf(temp_buf)

  -- Execute TOhtml command
  vim.cmd('LspStop')
  vim.cmd('TOhtml')
  vim.cmd('LspStart')

  -- Get the html buffer
  local html_buf = vim.api.nvim_get_current_buf()
  local html_content = table.concat(vim.api.nvim_buf_get_lines(html_buf, 0, -1, false), '\n')

  -- Create temporary file
  local tmp_html = os.tmpname() .. '.html'

  -- Write HTML to temp file
  local html_file = io.open(tmp_html, 'w')
  if html_file then
    html_file:write(html_content)
    html_file:close()
  else
    vim.api.nvim_err_writeln('Failed to write HTML to temporary file')
    return
  end

  -- Copy HTML to clipboard (system dependent)
  local copy_cmd = ''
  if vim.fn.has('mac') == 1 then
    -- macOS: Use pbcopy with HTML format
    copy_cmd = string.format('cat %s | pbcopy -Prefer html', tmp_html)
  elseif vim.fn.has('unix') == 1 then
    -- Linux with Wayland
    copy_cmd = string.format('wl-copy --type text/html < %s', tmp_html)
  elseif vim.fn.has('win32') == 1 then
    -- Windows: Use clip with HTML format
    -- Slight hack needed for Windows - create a .html file that will be opened
    local html_path = vim.fn.expand('~/temp_nvim_copy.html')
    vim.fn.system(string.format('copy %s %s', tmp_html:gsub('/', '\\'), html_path:gsub('/', '\\')))
    -- Open in default browser for copying
    vim.fn.system(string.format('start %s', html_path:gsub('/', '\\')))
    vim.api.nvim_out_write('HTML file opened in browser. Please copy from there.\n')
  else
    vim.api.nvim_err_writeln('Unsupported platform for clipboard operation')
    return
  end

  if vim.fn.has('unix') == 1 or vim.fn.has('mac') == 1 then
    local copy_result = vim.fn.system(copy_cmd)
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_err_writeln('Failed to copy to clipboard: ' .. copy_result)

      -- Fallback: open in browser
      local open_cmd = ''
      if vim.fn.has('mac') == 1 then
        open_cmd = string.format('open %s', tmp_html)
      else
        open_cmd = string.format('xdg-open %s', tmp_html)
      end
      vim.fn.system(open_cmd)
      vim.api.nvim_out_write('HTML file opened in browser. Please copy from there.\n')
    else
      vim.api.nvim_out_write('HTML copied to clipboard\n')
    end
  end

  -- Clean up temporary files (except on Windows where we'll leave it for the user)
  if not vim.fn.has('win32') == 1 then
    os.remove(tmp_html)
  end

  -- Clean up buffers
  vim.api.nvim_buf_delete(html_buf, { force = true })
  vim.api.nvim_buf_delete(temp_buf, { force = true })

  -- Return to original buffer and position
  vim.api.nvim_set_current_buf(current_buf)
  vim.api.nvim_win_set_cursor(current_win, cursor_pos)
end

-- Create command to call the function with range support
vim.api.nvim_create_user_command('TOclip', ToHtmlClipboard, { range = true })

-- Optional: Create keybinding for normal mode
vim.api.nvim_set_keymap('n', '<C-A-c>', ':TOclip<CR>', { noremap = true, silent = true })

-- Optional: Create keybinding for visual mode
vim.api.nvim_set_keymap('v', '<C-A-c>', ':\'<,\'>TOclip<CR>', { noremap = true, silent = true })
