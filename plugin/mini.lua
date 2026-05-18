-- mini.nvim: Collection of small independent plugins/modules
-- Loaded with sync = true so the statusline is visible immediately.

require('lazyload').on_vim_enter(function()
  vim.pack.add {
    { src = 'https://github.com/echasnovski/mini.nvim' },
  }

  -- Better Around/Inside textobjects
  require('mini.ai').setup { n_lines = 500 }

  -- Add/delete/replace surroundings (brackets, quotes, etc.)
  require('mini.surround').setup()

  -- Simple and easy statusline
  local statusline = require 'mini.statusline'
  statusline.setup { use_icons = vim.g.have_nerd_font }

  -- Set cursor location section to LINE:COLUMN
  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_location = function()
    return '%2l:%-2v'
  end

  -- Move lines/selections with Alt+hjkl
  require('mini.move').setup()
end, { sync = true })

-- vim: ts=2 sts=2 sw=2 et
