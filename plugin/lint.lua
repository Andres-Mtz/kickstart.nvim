-- nvim-lint: Linting

require('lazyload').on_vim_enter(function()
  vim.pack.add({
    { src = 'https://github.com/mfussenegger/nvim-lint' },
  })

  local lint = require 'lint'
  lint.linters_by_ft = {
    markdown = { 'markdownlint' },
  }

  -- Disable default linters for languages we don't use
  lint.linters_by_ft['clojure'] = nil
  lint.linters_by_ft['inko'] = nil
  lint.linters_by_ft['janet'] = nil
  lint.linters_by_ft['ruby'] = nil
  lint.linters_by_ft['terraform'] = nil

  -- Lint on enter, write, and leaving insert mode
  local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
    group = lint_augroup,
    callback = function()
      if vim.bo.modifiable then
        lint.try_lint()
      end
    end,
  })
end)

-- vim: ts=2 sts=2 sw=2 et
