-- diffview.nvim: Single tabpage interface for cycling through diffs
require("lazyload").on_vim_enter(function()
  vim.pack.add({
    'sindrets/diffview.nvim',
  })

  -- Keymaps
  vim.keymap.set('n', '<leader>gd', function() require('diffview').open() end, { desc = '[D]iff view' })
  vim.keymap.set('n', '<leader>gD', function() require('diffview').close() end, { desc = '[D]iff view close' })

  -- Setup diffview
  require('diffview').setup({
    enhanced_diff_hl = true,
    hooks = {
      diff_buf_win_enter = function(_, win)
        vim.wo[win].wrap = false
      end,
    },
  })
end)
