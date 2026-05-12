-- todo-comments: Highlight todo, notes, etc in comments

require('lazyload').on_vim_enter(function()
  vim.pack.add({
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/folke/todo-comments.nvim' },
  })

  require('todo-comments').setup { signs = false }
end)

-- vim: ts=2 sts=2 sw=2 et
