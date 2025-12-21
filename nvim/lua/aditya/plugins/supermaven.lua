local function accept_line(suggestion_function)
	local line = vim.fn.line(".")
	local line_count = vim.fn.line("$")

	suggestion_function()

	local added_lines = vim.fn.line("$") - line_count

	if added_lines > 1 then
		vim.api.nvim_buf_set_lines(0, line + 1, line + added_lines, false, {})
		local last_col = #vim.api.nvim_buf_get_lines(0, line, line + 1, true)[1] or 0
		vim.api.nvim_win_set_cursor(0, { line + 1, last_col })
	end
end

return {
	"supermaven-inc/supermaven-nvim",
	config = function()
		require("supermaven-nvim").setup({
			color = {
				suggestion_color = "#5a5a5a",
				cterm = 244,
			},
			disable_keymaps = true,
		})

		local api = require("supermaven-nvim.api")
		local completion_preview = require("supermaven-nvim.completion_preview")
		vim.keymap.set("n", "<leader>sm", function()
			api.toggle()
		end, { desc = "Exit terminal mode" })
		vim.keymap.set("i", "<C-CR>", function()
			accept_line(completion_preview.on_accept_suggestion)
		end, { desc = "Accept completion", noremap = true, silent = true })
		vim.keymap.set("i", "<C-]>", completion_preview.on_dispose_inlay, { noremap = true, silent = true })
	end,
}
