return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		opts = {
			auto_install = true,
			highlight = { enable = true, additional_vim_regex_highlighting = false },
			indent = { enable = true },
		},
		config = function()
			local ts = require("nvim-treesitter")
			---@diagnostic disable-next-line: missing-fields
			ts.install({ "c", "lua", "cpp", "json", "yaml", "glsl", "zig", "asm", "markdown", "markdown_inline" })
			vim.treesitter.language.register("glsl", "conf")

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
				callback = function(args)
					if pcall(vim.treesitter.start, args.buf) then
						vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end,
			})
		end,
	},
}
