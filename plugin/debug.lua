-- Debug: nvim-dap + dap-ui + nvim-nio + mason-nvim-dap + dap-go

require('lazyload').on_vim_enter(function()
  vim.pack.add({
    -- mason.nvim must be on the runtimepath before mason-nvim-dap is required,
    -- since mason-nvim-dap immediately requires 'mason-core.log' at the top of
    -- its init.lua. vim.pack deduplicates by path, so adding it here as well as
    -- in lsp.lua is safe and causes no double-clone.
    { src = 'https://github.com/mason-org/mason.nvim' },
    { src = 'https://github.com/nvim-neotest/nvim-nio' },
    { src = 'https://github.com/mfussenegger/nvim-dap' },
    { src = 'https://github.com/rcarriga/nvim-dap-ui' },
    { src = 'https://github.com/jay-babu/mason-nvim-dap.nvim' },
    { src = 'https://github.com/leoluz/nvim-dap-go' },
  })

  -- Ensure mason is initialized before mason-nvim-dap tries to use it.
  -- mason.setup() is idempotent, so calling it again in lsp.lua is harmless.
  require('mason').setup {}

  local dap = require 'dap'
  local dapui = require 'dapui'

  -- mason-nvim-dap: auto-install debug adapters
  require('mason-nvim-dap').setup {
    automatic_installation = true,
    handlers = {},
    ensure_installed = {
      'delve',
    },
  }

  -- Dap UI setup
  dapui.setup {
    icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
    controls = {
      icons = {
        pause = '⏸',
        play = '▶',
        step_into = '⏎',
        step_over = '⏭',
        step_out = '⏮',
        step_back = 'b',
        run_last = '▶▶',
        terminate = '⏹',
        disconnect = '⏏',
      },
    },
  }

  -- Auto open/close dap-ui
  dap.listeners.after.event_initialized['dapui_config'] = dapui.open
  dap.listeners.before.event_terminated['dapui_config'] = dapui.close
  dap.listeners.before.event_exited['dapui_config'] = dapui.close

  -- Go debugger
  require('dap-go').setup {
    delve = {
      detached = vim.fn.has 'win32' == 0,
    },
  }

  -- Keymaps
  vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
  vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
  vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
  vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
  vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
  vim.keymap.set('n', '<leader>B', function()
    dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
  end, { desc = 'Debug: Set Breakpoint' })
  vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })
end)

-- vim: ts=2 sts=2 sw=2 et
