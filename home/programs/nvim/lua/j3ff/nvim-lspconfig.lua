-- https://github.com/neovim/nvim-lspconfig
--

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local wk = require("which-key")

  wk.register({
    g = {
      d = { "<cmd>Telescope lsp_definitions<cr>", "Go to definition" },
      D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to declaration" },
      i = { "<cmd>Telescope lsp_implementations<cr>", "Go to implementation" },
      r = { "<cmd>Telescope lsp_references<cr>", "List references" },
      t = { "<cmd>Telescope lsp_type_definitions<cr>", "Go to type definition" },
    },
    K = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Display hover info for symbol" },
    ["<C-k>"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Display hover info for symbol" },
    ["["] = {
      d = { "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", "Go to previous error" },
    },
    ["]"] = {
      d = { "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", "Go to next error" },
    },
  }, { buffer = bufnr })

  wk.register({
    l = {
      name = "Language Server",
      a = { "<cmd>Telescope lsp_code_actions<cr>", "Code actions" },
      d = { "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>", "Error details" },
      e = { "<cmd>Telescope lsp_workspace_diagnostics<cr>", "Show errors" },
      f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format buffer" },
      r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename symbol" },
      v = { "<cmd>Telescope lsp_range_code_actions<cr>", "Code actions for range" },
      w = {
        name = "Workspace",
        a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", "Add workspace folder" },
        l = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", "List workspace folders" },
        r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", "Remove workspace folder" },
      },
    },
    w = {
      name = "Workspace Search",
      s = { "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Find symbols"},
    },
  }, { buffer = bufnr, prefix = "<space>" })
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local nvim_lsp = require('lspconfig')
local servers = { 'pyright' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

