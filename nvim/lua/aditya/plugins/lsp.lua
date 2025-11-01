return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		"saghen/blink.cmp",
	},
	config = function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))

		require("mason").setup()
		local ensure_installed = {
			"lua_ls",
			"clangd",
			-- "gopls",
			-- "zls",
			-- "ruff",
			-- "basedpyright",
			"stylua",
		}
		---@diagnostic disable-next-line: missing-fields
		require("mason-lspconfig").setup({})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("lspconfig").lua_ls.setup({
			capabilities = vim.tbl_deep_extend("force", {}, capabilities, {}),
			server_capabilities = {
				semanticTokensProvider = vim.NIL,
			},
			settings = {
				Lua = {
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		})

		require("lspconfig").clangd.setup({ capabilities = vim.tbl_deep_extend("force", {}, capabilities, {}) })
		require("lspconfig").zls.setup({
			cmd = { "zls" },
			capabilities = vim.tbl_deep_extend("force", {}, capabilities, {}),
			settings = {
				zls = {
					semantic_tokens = "partial",
				},
			},
		})
		--require("lspconfig").gopls.setup({ capabilities = vim.tbl_deep_extend("force", {}, capabilities, {}) })
		--require("lspconfig").ruff.setup({
		--	capabilities = vim.tbl_deep_extend("force", {}, capabilities, {}),
		--	settings = {
		--		logLevel = "debug",
		--	},
		--})
		--require("lspconfig").basedpyright.setup({
		--	capabilities = vim.tbl_deep_extend("force", {}, capabilities, {}),
		--	settings = {
		--		basedpyright = {
		--			disableOrganizeImports = true,
		--		},
		--		python = {
		--			analysis = {
		--				ignore = { "*" },
		--			},
		--		},
		--	},
		--})
	end,
}
