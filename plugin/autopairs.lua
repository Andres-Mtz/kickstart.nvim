-- autopairs: Auto-close brackets, quotes, etc.

require('lazyload').on_vim_enter(function()
  vim.pack.add({
    { src = 'https://github.com/windwp/nvim-autopairs' },
  })

  require('nvim-autopairs').setup {}
end)

-- vim: ts=2 sts=2 sw=2 et
