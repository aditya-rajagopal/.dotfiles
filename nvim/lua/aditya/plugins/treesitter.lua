return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = function()
			require("nvim-treesitter.install").update({ with_sync = true })()
		end,
		compilers = { "clang" },
		opts = {
			ensure_installed = { "c", "lua", "cpp", "json", "yaml", "glsl", "zig", "asm" },
			auto_install = true,
			highlight = { enable = true, additional_vim_regex_highlighting = false },
			indent = { enable = true },
		},
		config = function(_, opts)
			local config = require("nvim-treesitter.configs")
			---@diagnostic disable-next-line: missing-fields
			config.setup(opts)
			vim.treesitter.language.register("glsl", "conf")
		end,
	},
	{
		"nvim-treesitter/playground",
	},
}
