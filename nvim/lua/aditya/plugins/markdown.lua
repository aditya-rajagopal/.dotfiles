-- return {
-- 	"MeanderingProgrammer/render-markdown.nvim",
-- 	dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you use the mini.nvim suite
-- 	---@module 'render-markdown'
-- 	---@type render.md.UserConfig
-- 	opts = {},
-- }
return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	-- Completion for `blink.cmp`
	dependencies = { "saghen/blink.cmp" },
}
