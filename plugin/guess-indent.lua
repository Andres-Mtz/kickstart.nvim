-- guess-indent: Detect tabstop and shiftwidth automatically

require('lazyload').on_vim_enter(function()
  vim.pack.add({
    { src = 'https://github.com/NMAC427/guess-indent.nvim' },
  })

  require('guess-indent').setup {}
end)

-- vim: ts=2 sts=2 sw=2 et
