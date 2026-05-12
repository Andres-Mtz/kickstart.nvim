-- oil.nvim: Edit the filesystem like a buffer, replaces netrw
-- https://github.com/stevearc/oil.nvim
--
-- Key bindings (inside an oil buffer):
--   <CR>       -- Open file / enter directory
--   -          -- Go to parent directory
--   _          -- Open the current working directory
--   gs         -- Change sort
--   gx         -- Open file with system default app
--   g.         -- Toggle hidden files
--   g\         -- Toggle trash
--
-- netrw is disabled in init.lua via:
--   vim.g.loaded_netrw = 1
--   vim.g.loaded_netrwPlugin = 1

require('lazyload').on_vim_enter(function()
  vim.pack.add({
    -- nvim-web-devicons is already added by telescope.lua; vim.pack deduplicates.
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
    { src = 'https://github.com/stevearc/oil.nvim' },
  })

  require('oil').setup {
    -- Use the file icon column (requires a Nerd Font)
    columns = vim.g.have_nerd_font and { 'icon' } or {},

    -- Preserve window layout when opening a file
    delete_to_trash = true,

    -- Skip confirmation for simple deletes
    skip_confirm_for_simple_edits = true,

    view_options = {
      -- Show hidden files by default (toggle with g.)
      show_hidden = false,
      -- Sort dotfiles after regular files
      natural_order = true,
    },

    float = {
      -- Optional: open oil in a floating window with <leader>-
      padding = 2,
    },
  }

  -- Open oil when nvim is started with no file/directory arguments
  if vim.fn.argc() == 0 then
    require('oil').open()
  end

  -- Open parent directory of current file (replaces the netrw `-` binding)
  vim.keymap.set('n', '-', '<cmd>Oil<CR>', { desc = 'Open parent directory (oil)' })

  -- Open oil in a floating window
  vim.keymap.set('n', '<leader>-', function()
    require('oil').open_float()
  end, { desc = 'Open oil (floating)' })
end)

-- vim: ts=2 sts=2 sw=2 et
