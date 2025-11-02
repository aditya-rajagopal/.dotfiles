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

		vim.lsp.config("lua_ls", {
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
		vim.lsp.enable("lua_ls", true)

		vim.lsp.config("clangd", { capabilities = vim.tbl_deep_extend("force", {}, capabilities, {}) })
		vim.lsp.enable("clangd", true)
		vim.lsp.config("zls", {
			cmd = { "zls" },
			capabilities = vim.tbl_deep_extend("force", {}, capabilities, {}),
			settings = {
				zls = {
					semantic_tokens = "partial",
					enable_build_on_save = true,
				},
			},
		})
		vim.lsp.enable("zls", true)
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
