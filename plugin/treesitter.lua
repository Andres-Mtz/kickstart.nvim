-- nvim-treesitter: Highlight, edit, and navigate code

require('lazyload').on_vim_enter(function()
  -- Build hook: run :TSUpdate on install/update
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      if ev.data.spec.name == 'nvim-treesitter' then
        vim.cmd 'TSUpdate'
      end
    end,
  })

  vim.pack.add({
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  })

  require('nvim-treesitter').setup()

  -- Install parsers
  local parsers = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc', 'ts', 'al' }
  for _, parser in ipairs(parsers) do
    pcall(function()
      vim.treesitter.language.add(parser)
    end)
  end

  -- Enable treesitter highlighting for all buffers
  vim.api.nvim_create_autocmd('FileType', {
    callback = function()
      pcall(vim.treesitter.start)
    end,
  })
end)

-- vim: ts=2 sts=2 sw=2 et
