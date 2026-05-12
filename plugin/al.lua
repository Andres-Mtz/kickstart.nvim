-- AL Language support for Microsoft Dynamics 365 Business Central
--
-- Two community plugins are installed side-by-side, gated by an env var so
-- only one is active per Neovim session.
--
-- Usage (PowerShell):
--   $env:NVIM_APPNAME = "nvim-vimpack"; nvim   -- default: abonckus/al.nvim
--   $env:AL_PLUGIN = "drs76"; nvim              -- use drs76/ALNvim
--   Remove-Item Env:AL_PLUGIN                   -- back to default
--
-- Both plugins reuse the AL Language Server bundled in the Microsoft AL
-- VS Code extension (ms-dynamics-smb.al).

local al_plugin = vim.env.AL_PLUGIN or 'abonckus'
local enabled = not vim.g.vscode

if not enabled then
  return
end

local vscode_extensions_path = vim.fn.expand '$USERPROFILE/.vscode/extensions/'

if al_plugin == 'abonckus' then
  -- Load on FileType al
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'al',
    once = true,
    callback = function()
      vim.pack.add({
        { src = 'https://github.com/abonckus/al.nvim' },
        -- Dependencies (some already added by debug.lua, vim.pack deduplicates by path)
        { src = 'https://github.com/nvim-neotest/nvim-nio' },
        { src = 'https://github.com/mfussenegger/nvim-dap' },
        { src = 'https://github.com/rcarriga/nvim-dap-ui' },
        { src = 'https://github.com/theHamsta/nvim-dap-virtual-text' },
        { src = 'https://github.com/L3MON4D3/LuaSnip', version = vim.version.range('2.*') },
      })

      require('al').setup {
        vscodeExtensionsPath = vscode_extensions_path,
        integrations = { luasnip = true },
      }
    end,
  })
end

-- vim: ts=2 sts=2 sw=2 et
