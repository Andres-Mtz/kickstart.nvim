-- Neogit: Magit-like Git interface for Neovim
-- Uses vim.pack (built-in package manager)
require("lazyload").on_vim_enter(function()
  vim.pack.add({
    'NeogitOrg/neogit',
    'nvim-lua/plenary.nvim',           -- required dependency
    'sindrets/diffview.nvim',            -- optional but recommended for better diffs
  })

  -- Setup keymaps (will be registered after Neogit loads)
  vim.keymap.set('n', '<leader>gg', function() require('neogit').open() end, { desc = 'Neogit [g]it' })
  vim.keymap.set('n', '<leader>gc', function() require('neogit').open({ 'commit' }) end, { desc = 'Neogit [c]ommit' })
  vim.keymap.set('n', '<leader>gp', function() require('neogit').push() end, { desc = 'Neogit [p]ush' })
  vim.keymap.set('n', '<leader>gP', function() require('neogit').pull() end, { desc = 'Neogit [P]ull' })
  vim.keymap.set('n', '<leader>gb', function() require('neogit').branch() end, { desc = 'Neogit [b]ranch' })
  vim.keymap.set('n', '<leader>gl', function() require('neogit').log() end, { desc = 'Neogit [l]og' })

  -- Setup Neogit
  require('neogit').setup({
    disable_signs = true,               -- use gitsigns signs, avoid double-signs
    integrations = {
      telescope = true,                 -- integrate with telescope if available
      diffview = true,                  -- use diffview.nvim for diffs
    },
  })
end)
