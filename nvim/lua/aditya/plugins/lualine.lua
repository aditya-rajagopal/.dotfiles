return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					{
						"branch",
						fmt = function(str)
							if str == "main" or str == "master" then
								return ""
							end
							return str
						end,
					},
					{ "filename", path = 1 },
					"location",
					"diagnostics",
				},
				lualine_x = {
					{ "lsp_status", show_name = false, symbols = { done = "LSP connected" } },
					"diff",
					{ "datetime", style = "%H:%M:%S" },
				},
				lualine_y = {},
				lualine_z = {},
			},
			options = {
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
			},
		})
	end,
}
