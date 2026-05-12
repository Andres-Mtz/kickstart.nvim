-- Autocompletion: blink.cmp + LuaSnip + friendly-snippets

require('lazyload').on_vim_enter(function()
  -- Build LuaSnip jsregexp on install/update (non-Windows only, requires make)
  if vim.fn.has 'win32' == 0 and vim.fn.executable 'make' == 1 then
    vim.api.nvim_create_autocmd('PackChanged', {
      callback = function(ev)
        if ev.data.spec.name == 'LuaSnip' then
          vim.fn.system { 'make', 'install_jsregexp', '-C', ev.data.path }
        end
      end,
    })
  end

  vim.pack.add({
    { src = 'https://github.com/rafamadriz/friendly-snippets' },
    { src = 'https://github.com/L3MON4D3/LuaSnip', version = vim.version.range('2.*') },
    { src = 'https://github.com/Saghen/blink.cmp', version = vim.version.range('1.*') },
  })

  -- Load VSCode-style snippets
  require('luasnip.loaders.from_vscode').lazy_load()

  -- Setup blink.cmp
  ---@diagnostic disable-next-line: missing-fields
  require('blink.cmp').setup {
    keymap = {
      preset = 'default',
      -- Chain sidekick NES into <Tab>: jump/apply a Next Edit Suggestion first,
      -- then fall through to snippet expansion and the default preset behaviour.
      ['<Tab>'] = {
        'snippet_forward',
        function()
          local ok, sidekick = pcall(require, 'sidekick')
          return ok and sidekick.nes_jump_or_apply() or false
        end,
        'fallback',
      },
    },

    appearance = {
      nerd_font_variant = 'mono',
    },

    completion = {
      documentation = { auto_show = false, auto_show_delay_ms = 500 },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'lazydev' },
      providers = {
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
      },
    },

    snippets = { preset = 'luasnip' },

    fuzzy = { implementation = 'lua' },

    signature = { enabled = true },
  }
end)

-- vim: ts=2 sts=2 sw=2 et
