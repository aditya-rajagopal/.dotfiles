return {
	"supermaven-inc/supermaven-nvim",
	config = function()
		require("supermaven-nvim").setup({
			color = {
				suggestion_color = "#5a5a5a",
				cterm = 244,
			},
		})
	end,
}
