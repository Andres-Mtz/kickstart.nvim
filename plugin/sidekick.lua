-- sidekick.nvim: Copilot Next Edit Suggestions + AI CLI terminal
-- Requires copilot_ls (configured in lsp.lua via mason).
-- <Tab> NES integration lives in completion.lua (blink.cmp keymap).

require('lazyload').on_vim_enter(function()
  vim.pack.add {
    { src = 'https://github.com/folke/sidekick.nvim' },
  }

  require('sidekick').setup {
    nes = {
      enabled = function(buf)
        return vim.g.sidekick_nes ~= false and vim.b.sidekick_nes ~= false
      end,
      debounce = 100,
      diff = {
        inline = 'words',
        show = 'always',
      },
      signs = true,
      jumplist = true,
    },
    cli = {
      watch = true,
      win = {
        layout = 'right',
        split = { width = 80, height = 20 },
      },
      mux = {
        enabled = false, -- tmux/zellij not available on Windows
      },
      picker = 'telescope',
    },
  }

  -- Toggle/focus the AI CLI terminal (works in all modes)
  vim.keymap.set({ 'n', 't', 'i', 'x' }, '<M-a>', function()
    require('sidekick.cli').focus()
  end, { desc = 'Sidekick: Focus CLI' })

  -- Toggle the CLI window
  vim.keymap.set('n', '<leader>aa', function()
    require('sidekick.cli').toggle()
  end, { desc = 'Sidekick: Toggle [A]I CLI' })

  -- Select which CLI tool to open
  vim.keymap.set('n', '<leader>as', function()
    require('sidekick.cli').select()
  end, { desc = 'Sidekick: [S]elect CLI tool' })

  -- Detach / close CLI session
  vim.keymap.set('n', '<leader>ad', function()
    require('sidekick.cli').close()
  end, { desc = 'Sidekick: [D]etach CLI session' })

  -- Send prompt/context
  vim.keymap.set({ 'n', 'x' }, '<leader>at', function()
    require('sidekick.cli').send { msg = '{this}' }
  end, { desc = 'Sidekick: Send [T]his' })

  vim.keymap.set('n', '<leader>af', function()
    require('sidekick.cli').send { msg = '{file}' }
  end, { desc = 'Sidekick: Send [F]ile' })

  vim.keymap.set('x', '<leader>av', function()
    require('sidekick.cli').send { msg = '{selection}' }
  end, { desc = 'Sidekick: Send [V]isual selection' })

  -- Select from the prompt library
  vim.keymap.set({ 'n', 'x' }, '<leader>ap', function()
    require('sidekick.cli').prompt()
  end, { desc = 'Sidekick: Select [P]rompt' })

  -- Quick-open Claude directly
  vim.keymap.set('n', '<leader>ac', function()
    require('sidekick.cli').toggle { name = 'claude', focus = true }
  end, { desc = 'Sidekick: Toggle [C]laude' })
end)

-- vim: ts=2 sts=2 sw=2 et
