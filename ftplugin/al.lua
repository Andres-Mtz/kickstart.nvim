-- Buffer-local keymaps for AL (Business Central) files.
-- Loaded automatically by Neovim when filetype == "al".

local map = function(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { buffer = 0, desc = 'AL: ' .. desc, silent = true })
end

map('<leader>ab', '<cmd>AL build<cr>', '[B]uild')
map('<leader>ap', '<cmd>AL publish<cr>', '[P]ublish')
map('<leader>as', '<cmd>AL downloadSymbols<cr>', 'Download [S]ymbols')
map('<leader>aS', '<cmd>AL refreshSymbols<cr>', 'Refresh [S]ymbols')
map('<leader>ac', '<cmd>AL config<cr>', '[C]onfig (launch profile)')
map('<leader>ar', '<cmd>AL runObject<cr>', '[R]un object')
map('<leader>aa', '<cmd>AL authenticate<cr>', '[A]uthenticate')
map('<leader>ad', '<cmd>AL definition<cr>', 'AL [D]efinition')
map('<leader>al', '<cmd>AL lsp<cr>', '[L]SP info')
map('<leader>ao', '<cmd>AL openInBrowser<cr>', '[O]pen in browser')
map('<leader>aR', '<cmd>AL restartLsp<cr>', '[R]estart LSP')

-- Register the <leader>a group with which-key, if available.
pcall(function()
  require('which-key').add {
    { '<leader>a', group = '[A]L (Business Central)', buffer = 0 },
  }
end)
