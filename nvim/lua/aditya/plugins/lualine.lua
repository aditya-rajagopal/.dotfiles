return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- local lualine_nightfly = require("lualine.themes.nightfly")
		-- local new_colors = {
		-- 	blue = "#65d1ff",
		-- 	green = "3effdc",
		-- 	violet = "#ff61ef",
		-- 	yellow = "#ffda7b",
		-- 	black = "#000000",
		-- }
		--
		-- lualine_nightfly.normal.a.bg = new_colors.blue
		-- lualine_nightfly.insert.a.bg = new_colors.green
		-- lualine_nightfly.visual.a.bg = new_colors.violet
		-- lualine_nightfly.command = {
		-- 	a = {
		-- 		gui = "bold",
		-- 		bg = new_colors.yellow,
		-- 		fg = new_colors.black,
		-- 	},
		-- }
		require("lualine").setup({
			options = {
				-- theme = lualine_nightfly
				theme = "everforest",
			},
		})
	end,
}
