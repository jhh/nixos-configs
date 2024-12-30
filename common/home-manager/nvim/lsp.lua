--
-- LSP configuration
--
local lspconfig = require("lspconfig")
lspconfig.nil_ls.setup({})

lspconfig.basedpyright.setup({
	root_dir = lspconfig.util.root_pattern("pyproject.toml", ".git"),
	settings = {
		basedpyright = {
			disableOrganizeImports = true,
		},
		python = {
			analysis = {
				-- Ignore all files for analysis to exclusively use Ruff for linting
				ignore = { "*" },
			},
		},
	},
})

lspconfig.ruff.setup({
	init_options = {
		settings = {
			-- Ruff language server settings go here
		},
	},
})

lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
			},
		},
	},
})

-- vim.lsp.config("*", {
-- 	capabilities = {
-- 		textDocument = {
-- 			semanticTokens = {
-- 				multilineTokenSupport = true,
-- 			},
-- 		},
-- 	},
-- 	root_markers = { ".git" },
-- })
--
-- vim.lsp.config["nil"] = {
-- 	cmd = { "nil" },
-- 	filetypes = { "nix" },
-- 	root_markers = { "flake.nix" },
-- }
--
-- vim.lsp.config["luals"] = {
-- 	cmd = { "lua-language-server" },
-- 	filetypes = { "lua" },
-- 	root_markers = { ".git" },
-- 	settings = {
-- 		Lua = {
-- 			runtime = {
-- 				version = "LuaJIT",
-- 			},
-- 			workspace = {
-- 				checkThirdParty = false,
-- 				library = {
-- 					vim.env.VIMRUNTIME,
-- 				},
-- 			},
-- 		},
-- 	},
-- }
--
-- vim.lsp.config["ruff"] = {
-- 	cmd = { "ruff", "server" },
-- 	filetypes = { "python" },
-- 	root_markers = { "pyproject.toml" },
-- }
--
-- vim.lsp.config["pyright"] = {
-- 	cmd = { "pyright-langserver", "--stdio" },
-- 	filetypes = { "python" },
-- 	root_markers = { "pyproject.toml" },
-- }
--
-- vim.lsp.enable("nil")
-- vim.lsp.enable("luals")
-- vim.lsp.enable("ruff")
-- vim.lsp.enable("pyright")
