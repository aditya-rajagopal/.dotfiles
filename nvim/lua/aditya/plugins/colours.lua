-- function ColorMyPencils(color)
-- 	color = color or "rose-pine"
-- 	vim.cmd.colorscheme(color)
--
-- 	-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- 	-- vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
-- 	-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
-- 	-- vim.cmd("highlight TelescopeBorder guibg=none")
-- 	-- vim.cmd("highlight TelescopeTitle guibg=none")
-- end

-- return {
-- 	"neanias/everforest-nvim",
-- 	version = false,
-- 	lazy = false,
-- 	priority = 1000, -- make sure to load this before all the other start plugins
-- 	-- Optional; default configuration will be used if setup isn't called.
-- 	config = function()
-- 		local everforest = require("everforest")
-- 		everforest.setup({
-- 			background = "hard",
-- 			transparent_background_level = 0,
-- 			ui_contrast = "high",
-- 			italics = false,
-- 			disable_italic_comments = true,
-- 			inlay_hints_background = "dimmed",
-- 		})
-- 		ColorMyPencils("everforest")
-- 		vim.o.background = "dark"
-- 	end,
-- }

local colour_scheme = {
	"oskarnurm/koda.nvim",
	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		require("koda").setup({
			transparent = false,
			-- Override colors
			-- These will be merged into the active palette (Dark or Light)
			-- Example colors for dark background:
			colors = {
				bg = "#141414", -- editor background
				fg = "#fdfdf2", -- primary text color
				line = "#272727", -- line highlights
				paren = "#4d4d4d", -- matching brackets highlight
				keyword = "#a0a0b0", -- language syntax
				dim = "#50585d", -- line numbers, inlay hints
				comment = "#50585d", -- code comments
				border = "#ffffff", -- floating window borders
				emphasis = "#ffffff", -- bold text and prominent UI elements
				func = "#ffffff", -- function names and headings
				string = "#d9ba73", -- string literals
				const = "#d9ba73", -- numbers, booleans, and constants
				highlight = "#0058d0", -- search results and selection base
				info = "#8ebeec", -- diagnostic hints and informative icons
				success = "#86cd82", -- added git lines and positive diagnostics
				warning = "#d9ba73", -- modified git lines and warning diagnostics
				danger = "#ff7676", -- removed git lines and error diagnostics
			},
		})
		vim.cmd.colorscheme("koda")
	end,
}

return {
	colour_scheme,
	{
		"nvim-mini/mini.hipatterns",
		version = false,
		config = function()
			local hipatterns = require("mini.hipatterns")
			hipatterns.setup({
				highlighters = {
					hex_color = hipatterns.gen_highlighter.hex_color(),
				},
			})
		end,
	},
}
