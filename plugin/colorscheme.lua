-- Colorscheme: catppuccin
-- Loaded EAGERLY (not deferred) so the UI renders with the correct theme immediately.

vim.pack.add({
  { src = 'https://github.com/catppuccin/nvim', name = 'catppuccin' },
})

---@diagnostic disable-next-line: missing-fields
require('catppuccin').setup {
  transparent_background = false,
  float = {
    transparent = true,
    solid = true,
  },
  dim_inactive = {
    enabled = true,
    shade = 'dark',
    percentage = 0.15,
  },
  color_overrides = {},
  default_integrations = true,
  auto_integrations = false,
  integrations = {
    cmp = true,
    gitsigns = true,
    nvimtree = true,
    notify = true,
    mini = {
      enabled = true,
      indentscope_color = '',
    },
  },
}

vim.cmd.colorscheme 'catppuccin-mocha'

-- vim: ts=2 sts=2 sw=2 et
