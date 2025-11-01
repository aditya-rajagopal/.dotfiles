function ColorMyPencils(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)

	-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
	-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	-- vim.cmd("highlight TelescopeBorder guibg=none")
	-- vim.cmd("highlight TelescopeTitle guibg=none")
end

-- return {
-- 	{
-- 		"rose-pine/neovim",
-- 		name = "rose-pine",
-- 		lazy = false,
-- 		priority = 1000,
-- 		config = function()
-- 			require("rose-pine").setup({
-- 				-- disable_background = true,
-- 				styles = {
-- 					italic = false,
-- 				},
-- 				highlight_groups = {
-- 					["@lsp.type.comment.cpp"] = { fg = "muted" },
-- 				},
-- 			})
-- 			ColorMyPencils("rose-pine")
-- 		end,
-- 	},
-- }

-- return {
-- 	"tjdevries/colorbuddy.nvim",
-- 	priority = 1000,
-- 	config = function()
-- 		ColorMyPencils("gruvbuddy")
-- 		vim.cmd("highlight SignColumn guibg=none")
-- 	end,
-- }

-- return {
-- 	"shaunsingh/nord.nvim",
-- 	name = "nord",
-- 	priority = 1000,
-- 	config = function()
-- 		-- require("nord").setup({
-- 		-- 	-- disable_background = true,
-- 		-- 	-- disable_float_background = true,
-- 		-- 	-- disable_italics = true,
-- 		-- 	-- disable_underline = true,
-- 		-- 	-- transparent_background = true,
-- 		-- })
-- 		ColorMyPencils("nord")
-- 	end,
-- }

return {
	"neanias/everforest-nvim",
	version = false,
	lazy = false,
	priority = 1000, -- make sure to load this before all the other start plugins
	-- Optional; default configuration will be used if setup isn't called.
	config = function()
		local everforest = require("everforest")
		everforest.setup({
			background = "hard",
			transparent_background_level = 0,
			ui_contrast = "high",
			italics = true,
			disable_italic_comments = false,
			inlay_hints_background = "dimmed",
		})
		ColorMyPencils("everforest")
		vim.o.background = "dark"
	end,
}

-- return {
-- 	"catppuccin/nvim",
-- 	name = "catppuccin",
-- 	priority = 1000,
-- 	config = function()
-- 		require("catppuccin").setup({
-- 			compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
-- 			flavour = "mocha",
-- 			styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
-- 				comments = { "italic" }, -- Change the style of comments
-- 				conditionals = { "italic" },
-- 				loops = {},
-- 				functions = {},
-- 				keywords = { "italic" },
-- 				strings = { "italic" },
-- 				variables = {},
-- 				numbers = {},
-- 				booleans = {},
-- 				properties = {},
-- 				types = {},
-- 				operators = {},
-- 			},
-- 			integrations = {
-- 				cmp = true,
-- 				gitsigns = true,
-- 				treesitter = true,
-- 				telescope = {
-- 					enabled = true,
-- 				},
-- 				harpoon = true,
-- 			},
-- 			color_overrides = {
-- 				mocha = {
-- 					base = "#0b0b0b",
-- 					mantle = "#0b0b0b",
-- 					crust = "#0b0b0b",
-- 				},
-- 			},
-- 			custom_highlights = function(colours)
-- 				return {
-- 					["@module"] = { fg = colours.teal },
-- 					-- Zig highlights
-- 					["@lsp.type.errorTag.zig"] = { fg = colours.maroon },
-- 					["@lsp.type.builtin.zig"] = { fg = colours.yellow, style = { "bold" } },
-- 					["@lsp.type.method.zig"] = { fg = colours.sky, style = { "italic" } },
-- 				}
-- 			end,
-- 		})
-- 		ColorMyPencils("catppuccin")
-- 		vim.o.background = "dark"
-- 	end,
-- }

-- return {
-- 	"folke/tokyonight.nvim",
-- 	lazy = false,
-- 	priority = 1000,
-- 	opts = {},
-- 	config = function()
-- 		---@diagnostic disable-next-line: missing-fields
-- 		require("tokyonight").setup({
-- 			style = "night",
-- 			styles = {
-- 				comments = { italic = true },
-- 				keywords = { italic = true },
-- 				functions = {},
-- 				variables = {},
-- 				sidebars = "dark",
-- 				floats = "dark",
-- 			},
-- 			transparent = false,
-- 			disable_background = true,
-- 			terminal_colours = true,
-- 			---@param highlights tokyonight.Highlights
-- 			---@param colors ColorScheme
-- 			on_highlights = function(highlights, colors)
-- 				-- zig colours
-- 				highlights["@lsp.typemod.method.declaration.zig"] = {
-- 					fg = "#bb0000",
-- 				}
-- 				highlights["@lsp.type.string.zig"] = {
-- 					fg = "#bb0000",
-- 				}
-- 			end,
-- 		})
-- 		ColorMyPencils("tokyonight-storm")
-- 		vim.cmd("highlight SignColumn guibg=none")
-- 	end,
-- }

--return {
--	"bluz71/vim-nightfly-colors", name = "nightfly", lazy = false, priority = 1000,
--	config = function()
--		vim.g.nightflyNormalFloat = true
--		vim.g.nightflyUnderlineMatchParen = true
--		vim.cmd [[colorscheme nightfly]]
--	end
--}
