-- oil.nvim: A file explorer that lets you edit directories like buffers
require('lazyload').on_vim_enter(function()
  vim.pack.add {
    'stevearc/oil.nvim',
    'nvim-tree/nvim-web-devicons', -- optional
  }

  -- Keymaps
  vim.keymap.set('n', '-', function()
    require('oil').open()
  end, { desc = 'Oil: open parent directory' })
  vim.keymap.set('n', '<leader>o', function()
    require('oil').open()
  end, { desc = '[O]il: open' })
  vim.keymap.set('n', '<leader>of', function()
    require('oil').open_float()
  end, { desc = 'Oil: open [f]loat' })
  vim.keymap.set('n', '<leader>ot', function()
    require('oil').toggle_float()
  end, { desc = 'Oil: [t]oggle float' })

  -- Setup oil
  require('oil').setup {
    columns = {
      'icon',
      'permissions',
      'size',
      'mtime',
    },
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
    },
    win_options = {
      wrap = false,
    },
  }
end)
