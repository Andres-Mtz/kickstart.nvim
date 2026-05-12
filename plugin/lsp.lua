-- LSP Configuration
-- neovim/nvim-lspconfig + mason + mason-lspconfig + mason-tool-installer + fidget + lazydev

require('lazyload').on_vim_enter(function()
  vim.pack.add({
    { src = 'https://github.com/folke/lazydev.nvim' },
    { src = 'https://github.com/j-hui/fidget.nvim' },
    { src = 'https://github.com/mason-org/mason.nvim' },
    { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
    { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
  })

  -- Setup lazydev for Neovim Lua API completions
  require('lazydev').setup {
    library = {
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  }

  -- Setup fidget for LSP status updates
  require('fidget').setup {}

  -- LspAttach autocmd: configure keymaps and highlights per-buffer
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      -- Rename
      map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

      -- Code action
      map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

      -- Telescope-backed LSP pickers (skip in VS Code)
      if not vim.g.vscode then
        local builtin = require 'telescope.builtin'
        map('grr', builtin.lsp_references, '[G]oto [R]eferences')
        map('gri', builtin.lsp_implementations, '[G]oto [I]mplementation')
        map('grd', builtin.lsp_definitions, '[G]oto [D]efinition')
        map('gO', builtin.lsp_document_symbols, 'Open Document Symbols')
        map('gW', builtin.lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
        map('grt', builtin.lsp_type_definitions, '[G]oto [T]ype Definition')
      end

      -- Declaration
      map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      -- Document highlight on CursorHold
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      -- Toggle inlay hints
      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
        map('<leader>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
        end, '[T]oggle Inlay [H]ints')
      end
    end,
  })

  -- Diagnostic config
  vim.diagnostic.config {
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = vim.diagnostic.severity.ERROR },
    signs = vim.g.have_nerd_font and {
      text = {
        [vim.diagnostic.severity.ERROR] = '󰅚 ',
        [vim.diagnostic.severity.WARN] = '󰀪 ',
        [vim.diagnostic.severity.INFO] = '󰋽 ',
        [vim.diagnostic.severity.HINT] = '󰌶 ',
      },
    } or {},
    virtual_text = {
      source = 'if_many',
      spacing = 2,
      format = function(diagnostic)
        return diagnostic.message
      end,
    },
  }

  -- Capabilities: enhanced by blink.cmp
  local capabilities = require('blink.cmp').get_lsp_capabilities()

  -- Server configurations
  local servers = {
    clangd = {},
    copilot_ls = {}, -- Copilot LSP required by sidekick.nvim
    gopls = {},
    rust_analyzer = {},
    lua_ls = {
      settings = {
        Lua = {
          completion = {
            callSnippet = 'Replace',
          },
          diagnostics = { disable = { 'missing-fields' } },
        },
      },
    },
  }

  -- Mason setup
  require('mason').setup {}

  -- Ensure tools are installed
  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, {
    'stylua', -- Used to format Lua code
    'copilot-language-server', -- Copilot LSP server for sidekick.nvim
  })
  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  -- mason-lspconfig: auto-setup servers
  require('mason-lspconfig').setup {
    ensure_installed = {},
    automatic_installation = false,
    handlers = {
      function(server_name)
        local server = servers[server_name] or {}
        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
        require('lspconfig')[server_name].setup(server)
      end,
    },
  }
end)

-- vim: ts=2 sts=2 sw=2 et
